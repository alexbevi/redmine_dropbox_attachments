require 'redmine_dropbox/attachment_patch'
require 'redmine_dropbox/attachments_controller_patch'

AttachmentsController.send(:include, RedmineDropbox::AttachmentsControllerPatch)
Attachment.send(:include, RedmineDropbox::AttachmentPatch)