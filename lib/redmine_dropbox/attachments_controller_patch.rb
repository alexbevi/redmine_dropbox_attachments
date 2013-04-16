module RedmineDropbox
  module AttachmentsControllerPatch
    
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)

      if Redmine::VERSION.to_s >= "2.3"
        base.send(:include, Redmine23AndNewer)
      else
        base.send(:include, Redmine22AndOlder)
      end

      base.class_eval do
        unloadable
        before_filter :prepare_dropbox_redirect, :except => :destroy
        skip_before_filter :file_readable
      end
    end

    module ClassMethods
      def redirect_to_dropbox(path)
        client = Attachment.dropbox_client
        
        # XXX redmine_dropbox_attachments 1.x compatibility
        # if the file doesn't existing in the /base/project/class/filename location, try falling back to /base/filename
        ref = begin
          client.find(path)
        rescue Dropbox::API::Error::NotFound
          p = path.split("/")
          client.find([p[0], p[-1]].flatten.join("/"))
        end

        redirect_to ref.direct_url[:url]
      end
    end

    module Redmine23AndNewer
      def prepare_dropbox_redirect
        skip_redirection = false

        if @attachment.nil?
          # XXX Redmine 2.3+ ajax file upload handling
          # Since we uploads occur prior to an actual record being created,
          # the context needs to be parsed from the url.
          #   ex: http://url/projects/project_id/..../action_id
          ref = request.env["HTTP_REFERER"].split("/")

          klass   = ref[-2].singularize.titlecase
          record  = ref[-1].to_i
          project = if record > 0
            klass.constantize.find(record).project_id
          else
            ref[-3] 
          end

          filename = request.env["QUERY_STRING"].scan(/filename=(.*)/).flatten.first
          path = Attachment.dropbox_absolute_path(filename, klass, project)

          Attachment.set_context :class => klass, :project => project
          skip_redirection = true
        elsif @attachment.respond_to? :container
          if (@attachment.container.is_a?(Version) || @attachment.container.is_a?(Project))
            @attachment.increment_download
          end
        end

        path ||= @attachment.dropbox_path

        self.class.redirect_to_dropbox(path) unless skip_redirection
      end
    end

    module Redmine22AndOlder
      def prepare_dropbox_redirect
        if @attachment.respond_to? :container
          if (@attachment.container.is_a?(Version) || @attachment.container.is_a?(Project))
            @attachment.increment_download
          end
        end

        self.class.redirect_to_dropbox @attachment.dropbox_path
      end
    end
  
  end
end