class PlaylistsController < ApplicationController
  def index
  end

  def create
    user = RSpotify::User.new(request.env['omniauth.auth'])
    
    # デバッグ用：Refresh tokenとUser IDを表示
    puts "="*50
    puts "SPOTIFY_REFRESH_TOKEN=#{user.credentials['refresh_token']}"
    puts "SPOTIFY_USER_ID=#{user.id}"
    puts "="*50
    puts "Add these to your environment variables (.env file or shell profile)"
    
    spotify_playlist = RSpotify::Playlist.find_by_id(ENV['PLAYLIST_ID'])
    destroy_track(spotify_playlist)
    Playlist.destroy_all

    Playlist.scrape
    tracks = Playlist.all.flat_map do |list|
      RSpotify::Track.search("#{list.artist} #{list.track}", limit: 1, market: 'JP').flatten
    end.compact_blank
    spotify_playlist.add_tracks!(tracks)
    redirect_to({action: :index}, notice: 'プレイリストを作成しました（コンソールでRefresh Tokenを確認してください）')
  end

  private

  def destroy_track(playlist)
    return if playlist.total == 0 # プレイリストが空の場合は何もしない
    
    tracks_to_remove = playlist.tracks.map.with_index do |track, index|
      { uri: track.uri, positions: [index] }
    end
    
    playlist.remove_tracks!(tracks_to_remove, snapshot_id: playlist.snapshot_id) if tracks_to_remove.any?
  end
end
