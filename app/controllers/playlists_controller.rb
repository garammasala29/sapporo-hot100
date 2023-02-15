class PlaylistsController < ApplicationController
  def index
  end

  def spotify
    RSpotify::User.new(request.env['omniauth.auth'])
    spotify_playlist = RSpotify::Playlist.find_by_id(ENV['PLAYLIST_ID'])
    positions = (0..spotify_playlist.total - 1).to_a
    spotify_playlist.remove_tracks!(positions, snapshot_id: spotify_playlist.snapshot_id)
    # Playlist.scrape
    tracks = Playlist.all.flat_map do |list|
      RSpotify::Track.search("artist:#{list.artist} track:#{list.track}", limit: 1).flatten
    end.compact_blank
    spotify_playlist.add_tracks!(tracks)
  end
end
