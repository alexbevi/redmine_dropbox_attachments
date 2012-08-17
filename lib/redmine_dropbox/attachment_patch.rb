module RedmineDropbox
  module AttachmentPatch
    
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
        # after_validation :save_to_dropbox
        # before_destroy   :delete_from_dropbox
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def save_to_dropbox
        if @temp_file && (@temp_file.size > 0)
          logger.debug "[redmine_dropbox] Uploading to #{disk_filename}"
          # TODO save disk_filename, @temp_file.read
          md5 = Digest::MD5.new
          self.digest = md5.hexdigest
        end
        @temp_file = nil # so that the model's original after_save block skips writing to the fs
      end

      def delete_from_dropbox
        logger.debug "[redmine_dropbox] Deleting #{disk_filename}"
        # TODO delete disk_filename
      end
    end
  end
end