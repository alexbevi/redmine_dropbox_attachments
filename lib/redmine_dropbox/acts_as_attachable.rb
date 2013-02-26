module Redmine
  module Acts
    module Attachable

      module InstanceMethods
        alias_method :orig_save_attachments, :save_attachments
        
        def self.included(base)
          base.extend ClassMethods
        end

        def save_attachments(attachments, author=User.current)
          Attachment.set_context self
          orig_save_attachments(attachments, author=User.current)
        end
        
      end
    end
  end
end