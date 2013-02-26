module Redmine
  module Acts
    module Attachable

      module InstanceMethods
        alias_method :orig_save_attachments, :save_attachments
        
        def save_attachments(attachments, author=User.current)
          if attachments.is_a?(Array)
            attachments.each do |attachment|
              a = nil
              if file = attachment['file']
                next unless file.size > 0
                
                Attachment.set_context self
              end
            end
          end
          orig_save_attachments attachments, author
        end
      end
      
    end
  end
end
