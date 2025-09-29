# Sapporo Hot100 🎵

[SAPPORO HOT 100 - 週間楽曲チャート｜82.5 FM NORTH WAVE ノースウェーブ](https://www.fmnorth.co.jp/hot100/)のランキングをSpotify APIを使ってプレイリスト化しました。

**✨ 毎週日曜日17:00に自動更新されます！**

<img width="981" alt="image" src="https://user-images.githubusercontent.com/69446373/220035413-d0af20c1-906f-482a-802c-24985f1e6efe.png">

🎧 **プレイリスト:** https://open.spotify.com/playlist/6FZZhVECp3WxI5JOrQFDct?si=4186e1000ea64ef0

---

## 🚀 自動化システム

このプロジェクトは**完全自動化**されており、毎週最新のランキングでプレイリストが更新されます。

### 📅 自動実行スケジュール
- **実行タイミング**: 毎週日曜日 17:00 (JST)
- **実行環境**: GitHub Actions (クラウド実行)
- **手動操作**: 不要

### 🔧 自動実行の仕組み
1. **ランキング取得**: NORTH WAVEサイトをスクレイピング
2. **楽曲検索**: Spotify APIで楽曲を検索
3. **プレイリスト更新**: 既存楽曲を削除し、新しいランキングを追加

---

## 🛠️ 手動実行方法

### ローカルでの実行
```bash
# Rakeタスクで実行
bundle exec rails playlist:update

# Webアプリで実行
rails server
# http://localhost:3000 でプレイリスト作成ボタンをクリック
```

### GitHub Actionsでの手動実行
1. [Actions ページ](https://github.com/garammasala29/sapporo-hot100/actions) にアクセス
2. "Update Playlist" ワークフローをクリック  
3. "Run workflow" ボタンで実行

---

## ⚙️ 環境設定

### 必要な環境変数
```bash
CLIENT_ID=your_spotify_client_id
CLIENT_SECRET=your_spotify_client_secret
PLAYLIST_ID=your_playlist_id
SPOTIFY_REFRESH_TOKEN=your_refresh_token
SPOTIFY_USER_ID=your_spotify_user_id
```

### ローカル環境のセットアップ
```bash
# 依存関係をインストール
bundle install

# データベースセットアップ
rails db:setup

# 初回認証でRefresh Tokenを取得
rails server
# ブラウザでSpotify認証を実行
```

---

## 🔐 認証システム

### OAuth認証 (初回のみ)
- Spotifyアカウントでのログインが必要
- Refresh Tokenを取得するために実行

### Refresh Token認証 (自動実行時)
- 長期間有効な認証トークンを使用
- ブラウザ操作不要で自動実行可能

---

## 📊 技術スタック

- **Backend**: Ruby on Rails 7.0
- **Database**: PostgreSQL (Local), SQLite3 (CI)
- **API**: Spotify Web API
- **スクレイピング**: Mechanize
- **認証**: OmniAuth + Spotify OAuth
- **自動化**: GitHub Actions
- **スケジューリング**: Cron (GitHub Actions)

---

## 📁 プロジェクト構造

```
├── app/
│   ├── controllers/playlists_controller.rb  # プレイリスト操作
│   └── models/playlist.rb                   # ランキングデータ管理
├── lib/tasks/playlist.rake                  # 自動実行タスク
├── config/
│   ├── initializers/rspotify.rb            # Spotify認証設定
│   └── routes.rb                           # ルーティング
└── .github/workflows/update_playlist.yml   # GitHub Actions設定
```

---

## 🔄 実行ログの確認

### GitHub Actions
- [Actions ページ](https://github.com/garammasala29/sapporo-hot100/actions)で実行履歴を確認

### ローカル実行
```bash
# 実行ログを確認
tail -f log/playlist_update.log
```

---

## 🆘 トラブルシューティング

### よくある問題
- **Refresh Token期限切れ**: 再度OAuth認証を実行
- **楽曲が見つからない**: Spotify検索で該当楽曲が存在しない場合は自動的にスキップ
- **GitHub Actions失敗**: Secrets設定を確認

### サポート
プロジェクトに関する問題は [Issues](https://github.com/garammasala29/sapporo-hot100/issues) で報告してください。

---

## 📝 ライセンス

このプロジェクトは個人利用目的で作成されています。
