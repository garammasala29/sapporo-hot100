Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['CLIENT_ID'], ENV['CLIENT_SECRET'], scope: 'playlist-modify-public'
end
