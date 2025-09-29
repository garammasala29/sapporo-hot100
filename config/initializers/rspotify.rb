# RSpotify認証
# アプリケーション初期化時にSpotify APIが利用可能な場合のみ認証を実行
if ENV['CLIENT_ID'].present? && ENV['CLIENT_SECRET'].present?
  begin
    RSpotify.authenticate(ENV['CLIENT_ID'], ENV['CLIENT_SECRET'])
  rescue => e
    Rails.logger.warn "RSpotify authentication failed: #{e.message}" if defined?(Rails.logger)
  end
end