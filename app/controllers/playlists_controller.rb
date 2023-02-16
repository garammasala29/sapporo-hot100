class PlaylistsController < ApplicationController
  def index
  end

  def create
    RSpotify::User.new(request.env['omniauth.auth'])
    spotify_playlist = RSpotify::Playlist.find_by_id(ENV['PLAYLIST_ID'])
    destroy_track(spotify_playlist)
    Playlist.destroy_all

    Playlist.scrape
    tracks = Playlist.all.flat_map do |list|
      RSpotify::Track.search("#{list.artist} #{list.track}", limit: 1, market: 'JP').flatten
    end.compact_blank
    spotify_playlist.add_tracks!(tracks)
    redirect_to({action: :index}, notice: 'プレイリストを作成しました')
  end

  private

  def destroy_track(playlist)
    track_numbers = (0..playlist.total - 1).to_a
    playlist.remove_tracks!(track_numbers, snapshot_id: playlist.snapshot_id)
  end
end
