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
        redirect_to "#" # TODO dropbox url to @attachment.disk_filename
      end
    end
  end
end