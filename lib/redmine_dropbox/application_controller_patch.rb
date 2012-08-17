module RedmineDropbox
  module ApplicationControllerPatch
    
    def self.included(base) # :nodoc:
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)

      base.class_eval do
        unloadable
        attr_reader :dropbox_client
        before_filter :ensure_dropbox_client
      end
    end

    module ClassMethods
    end

    module InstanceMethods
      def ensure_dropbox_client
        @dropbox_client ||= RedmineDropbox::Client.authorize(request)
      end
    end
  end
end