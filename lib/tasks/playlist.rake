namespace :playlist do
  desc "Update Spotify playlist with latest tracks"
  task update: :environment do
    puts "Starting playlist update at #{Time.current}"
    
    begin
      # 環境変数からRefresh tokenを取得
      unless ENV['SPOTIFY_REFRESH_TOKEN']
        puts "Error: SPOTIFY_REFRESH_TOKEN environment variable is required."
        puts "Please set the refresh token in your environment variables."
        puts ""
        puts "To get refresh token:"
        puts "1. Run: bundle exec rails console"
        puts "2. Follow the instructions to get your refresh token"
        exit 1
      end
      
      refresh_token = ENV['SPOTIFY_REFRESH_TOKEN']
      user_id = ENV['SPOTIFY_USER_ID'] || 'default_user'
      
      # Refresh tokenを使ってアクセストークンを更新
      access_token = refresh_access_token(refresh_token)
      
      # ユーザーを認証（正しい形式）
      user_hash = {
        'credentials' => {
          'token' => access_token,
          'refresh_token' => refresh_token
        },
        'info' => {
          'id' => user_id
        }
      }
      
      user = RSpotify::User.new(user_hash)
      
      # RSpotifyの認証情報を手動で設定
      RSpotify::User.class_variable_set(:@@users_credentials, {
        user_id => {
          'token' => access_token,
          'refresh_token' => refresh_token
        }
      })
      
      # プレイリストを取得
      spotify_playlist = RSpotify::Playlist.find_by_id(ENV['PLAYLIST_ID'])
      
      # 既存のトラックを削除
      destroy_tracks(spotify_playlist, user)
      
      # データベースをクリア
      Playlist.destroy_all
      
      # 新しいデータをスクレイピング
      Playlist.scrape
      
      # トラックを検索して追加
      tracks = Playlist.all.flat_map do |list|
        RSpotify::Track.search("#{list.artist} #{list.track}", limit: 1, market: 'JP').flatten
      end.compact_blank
      
      spotify_playlist.add_tracks!(tracks) if tracks.any?
      
      puts "Playlist updated successfully! Added #{tracks.count} tracks."
      
    rescue => e
      puts "Error updating playlist: #{e.message}"
      puts e.backtrace
    end
  end
  
  private
  
  def refresh_access_token(refresh_token)
    require 'net/http'
    require 'json'
    require 'base64'
    
    uri = URI('https://accounts.spotify.com/api/token')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Basic #{Base64.strict_encode64("#{ENV['CLIENT_ID']}:#{ENV['CLIENT_SECRET']}")}"
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.body = "grant_type=refresh_token&refresh_token=#{refresh_token}"
    
    response = http.request(request)
    data = JSON.parse(response.body)
    
    if data['access_token']
      data['access_token']
    else
      raise "Failed to refresh token: #{data['error_description']}"
    end
  end
  
  def destroy_tracks(playlist, user)
    return if playlist.total == 0
    
    # すべてのトラックを取得
    tracks = playlist.tracks
    return if tracks.empty?
    
    # トラック数に応じてインデックス配列を作成
    track_positions = (0...tracks.length).to_a
    
    # トラック削除
    playlist.remove_tracks!(track_positions)
  end
end