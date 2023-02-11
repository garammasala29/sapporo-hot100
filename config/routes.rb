Rails.application.routes.draw do
  root 'users#index'
  get '/auth/:provider/callback', to: 'users#spotify'
end
