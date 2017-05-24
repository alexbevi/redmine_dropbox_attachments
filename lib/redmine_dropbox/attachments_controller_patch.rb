module RedmineDropbox
  module AttachmentsControllerPatch

    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

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

    module InstanceMethods
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
        # redirecting to dropbox is not necessary only an ajax upload is being done,
        # which is determined by having an uninitialized @attachment
        skip_redirection = false

        # XXX Redmine 2.3+ ajax file upload handling
        if @attachment.nil?
          # Since we uploads occur prior to an actual record being created,
          # the context needs to be parsed from the url.
          #   ex: http://url/projects/project_id/..../action_id
          ref = request.env["HTTP_REFERER"].split("/")
          # We also only want the url parts that follow .../projects/ if possible.
          # If not, just use the standard split HTTP_REFERER
          ref = ref[ref.index("projects") + 1 .. -1] if ref.index("projects")

          # For "Issues", the url is longer than "News" or "Documents"
          klass_idx = (ref.length > 2) ? -2 : -1
          klass = ref[klass_idx].singularize.titlecase
          # For attachments in the "File" area, we want to identify
          # as a "Project" since there technically is no "File" container
          klass = "Project" if klass == "File"

          # Try to match an id (regardless of whether it'll be valid)
          record  = ref[-1].to_i
          project = if record > 0
            klass.constantize.find(record).project_id
          else
            ref[0] # we won't have a project AND a record, so this shouldn't fail
          end

          filename = request.env["QUERY_STRING"].scan(/filename=(.*)/).flatten.first
          path = Attachment.dropbox_absolute_path(filename, klass, project)

          Attachment.set_context :class => klass, :project => project
          skip_redirection = true
        else
          if @attachment.respond_to?(:container)
            Attachment.set_context @attachment.container
            # increment the download counter if necessary
            @attachment.increment_download if (@attachment.container.is_a?(Version) || @attachment.container.is_a?(Project))
          end
        end

        path ||= @attachment.dropbox_path

        redirect_to_dropbox(path) unless skip_redirection
      end
    end

    module Redmine22AndOlder
      def prepare_dropbox_redirect
        if @attachment.respond_to? :container
          if (@attachment.container.is_a?(Version) || @attachment.container.is_a?(Project))
            @attachment.increment_download
          end
        end

        redirect_to_dropbox @attachment.dropbox_path
      end
    end

  end
end
