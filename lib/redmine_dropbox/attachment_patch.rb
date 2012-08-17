module RedmineDropbox
  module AttachmentPatch
    
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
        after_validation :save_to_dropbox
        before_destroy   :delete_from_dropbox
      end
    end

    module ClassMethods
      def dropbox_client
        settings = Setting.find_by_name("plugin_redmine_dropbox_attachments")

        raise l(:dropbox_plugin_not_configured) if settings.nil?
        
        k = settings.value

        raise l(:dropbox_not_authorized) unless k["DROPBOX_TOKEN"] && k["DROPBOX_SECRET"]
        
        @@dropbox_client ||= Dropbox::API::Client.new :token => k["DROPBOX_TOKEN"], :secret => k["DROPBOX_SECRET"]
      end
    end

    module InstanceMethods
      def save_to_dropbox
        if @temp_file && (@temp_file.size > 0)
          logger.debug "[redmine_dropbox_attachments] Uploading #{disk_filename}"
          
          Attachment.dropbox_client.upload disk_filename, @temp_file.read
          md5 = Digest::MD5.new
          self.digest = md5.hexdigest
        end
        @temp_file = nil # so that the model's original after_save block skips writing to the fs
      end

      def delete_from_dropbox
        logger.debug "[redmine_dropbox_attachments] Deleting #{disk_filename}"
        f = Attachment.dropbox_client.find disk_filename
        f.destroy
      end
    end
  end
end