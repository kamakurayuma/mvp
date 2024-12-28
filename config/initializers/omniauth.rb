Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, 
             Rails.application.credentials.dig(:google, :google_client_id), 
             Rails.application.credentials.dig(:google, :google_client_secret),
             scope: 'email',
             prompt: 'select_account'
  end
  