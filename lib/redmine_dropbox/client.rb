module RedmineDropbox
  class Client
    def authorize
      consumer = Dropbox::API::OAuth.consumer(:authorize)
      request_token = consumer.get_request_token
      request_token.authorize_url(:oauth_callback => 'http://yoursite.com/callback')
      # Here the user goes to Dropbox, authorizes the app and is redirected
      # The oauth_token will be available in the params
      request_token.get_access_token(:oauth_verifier => oauth_token)
    end
  end
end