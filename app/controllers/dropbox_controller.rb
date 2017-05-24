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
      tmp["REQUEST_TOKEN"] = YAML::dump(request_token)
      settings.value = tmp
      settings.save

      # Store the token and secret in session to use in callback
      session[:request_token] = request_token.token
      session[:request_token_secret] = request_token.secret

      redirect_to request_token.authorize_url(:oauth_callback => url_for(:action => 'authorize'))
    else
      # Create new request_token
      consumer = Dropbox::API::OAuth.consumer(:authorize)
      request_token = OAuth::RequestToken.new(consumer, session[:request_token], session[:request_token_secret])

      tmp = settings.value

      # comment below line to use new request_token
      #request_token = YAML::load(tmp["REQUEST_TOKEN"])
      access_token  = request_token.get_access_token(:oauth_verifier => params[:oauth_token])

      tmp["DROPBOX_TOKEN"]  = access_token.token
      tmp["DROPBOX_SECRET"] = access_token.secret
      tmp.delete("REQUEST_TOKEN")
      settings.value = tmp
      settings.save

      flash[:notice] = l(:dropbox_authorization_successful)
      redirect_to "/settings/plugin/#{PLUGIN_BASE}"
    end
  end
end
