class DropboxController < ApplicationController
  PLUGIN_BASE = "redmine_dropbox_attachments"

  def authorize
    settings = Setting.find_by_name("plugin_#{PLUGIN_BASE}")
    
    if settings.nil?  
      flash[:warning] = l(:warning_settings_unsaved)
      redirect_to "/settings/plugin/#{PLUGIN_BASE}"
    elsif !params[:oauth_token]
      consumer = Dropbox::API::OAuth.consumer(:authorize)
      request_token = consumer.get_request_token

      tmp = settings.value
      tmp["DROPBOX_TOKEN"] = YAML::dump(request_token)
      settings.value = tmp
      settings.save

      redirect_to request_token.authorize_url(:oauth_callback => url_for(:action => 'authorize'))
    else
      tmp = settings.value

      request_token = YAML::load(tmp["DROPBOX_TOKEN"])
      access_token  = request_token.get_access_token(:oauth_verifier => params[:oauth_token])

      tmp["DROPBOX_TOKEN"]  = access_token.token
      tmp["DROPBOX_SECRET"] = access_token.secret
      tmp.delete("DROPBOX_TOKEN")
      settings.value = tmp
      settings.save

      flash[:notice] = l(:dropbox_authorization_successful)
      redirect_to "/settings/plugin/#{PLUGIN_BASE}"
    end
  end
end