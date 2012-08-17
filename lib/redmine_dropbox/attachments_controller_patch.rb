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
        @attachment.increment_download if (@attachment.container.is_a?(Version) || @attachment.container.is_a?(Project))
        f = Attachment.dropbox_client.find @attachment.disk_filename
        redirect_to f.direct_url[:url]
      end
    end
  end
end