Rails.application.routes.draw do
  root 'playlists#index'
  get '/auth/:provider/callback', to: 'playlists#spotify'
end
