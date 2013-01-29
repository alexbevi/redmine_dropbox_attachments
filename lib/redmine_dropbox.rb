require 'redmine_dropbox/attachment_patch'
require 'redmine_dropbox/attachments_controller_patch'
require 'redmine_dropbox/acts_as_attachable'

ActiveRecord::Base.send(:include, Redmine::Acts::Attachable)
AttachmentsController.send(:include, RedmineDropbox::AttachmentsControllerPatch)
Attachment.send(:include, RedmineDropbox::AttachmentPatch)