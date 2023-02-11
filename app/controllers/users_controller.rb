class UsersController < ApplicationController
  def index
  end

  def spotify
    spotify_user = RSpotify::User.new(request.env['omniauth.auth'])
    playlist = RSpotify::Playlist.find_by_id(ENV['PLAYLIST_ID'])
  end
end
