require 'redmine_dropbox'

Redmine::Plugin.register :redmine_dropbox_attachments do
  name        "Dropbox Attachment Storage"
  author      "Alex Bevilacqua"
  description "Use Dropbox for attachment storage"
  version     "0.0.1"

  settings :default => {
    'DROPBOX_SESSION' => nil,
  }, :partial => 'settings/dropbox_settings'

end

Dropbox::API::Config.app_key    = "wmofz74crudpszb"
Dropbox::API::Config.app_secret = "20py9be64g6chf9"
Dropbox::API::Config.mode       = "sandbox"