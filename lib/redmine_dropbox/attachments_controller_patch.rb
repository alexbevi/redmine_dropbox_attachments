module RedmineDropbox
  module AttachmentsControllerPatch
    
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
        before_filter :redirect_to_dropbox, :except => :destroy
        skip_before_filter :file_readable
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def redirect_to_dropbox
        if @attachment.respond_to? :container
          if (@attachment.container.is_a?(Version) || @attachment.container.is_a?(Project))
            @attachment.increment_download
          end
        end

        client, path = Attachment.dropbox_client, @attachment.dropbox_path.split("/")

        # XXX 1.x compatibility
        # if the file doesn't existing in the /base/project/class/filename location, try
        # falling back to /base/filename
        ref = begin
          client.find(path.join("/"))
        rescue Dropbox::API::Error::NotFound
          client.find([path[0], path[-1]].flatten.join("/"))
        end

        redirect_to ref.direct_url[:url]
      end
    end
  end
end