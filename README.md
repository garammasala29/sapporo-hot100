# Sapporo Hot100

[SAPPORO HOT 100](https://www.fmnorth.co.jp/hot100/)(82.5 FM NORTH WAVE)のランキングを、毎週Spotifyプレイリストに反映するスクリプトです。

プレイリスト: https://open.spotify.com/playlist/6FZZhVECp3WxI5JOrQFDct

## 仕組み

1. NORTH WAVEのサイトをスクレイピングしてランキングを取得
2. Spotify APIで各曲を検索
3. プレイリストの中身を丸ごと置き換える(`bin/update_playlist`)

GitHub Actionsで毎週日曜16:00 JSTに自動実行されます(`.github/workflows/update_playlist.yml`)。取得件数が想定を大きく下回る場合(ページ構成の変更など)や、認証エラーなどが起きた場合は処理を中断し、既存のプレイリストはそのまま残ります。この場合ワークフローは失敗として記録され、GitHubから通知が届きます。

## セットアップ

```bash
bundle install
```

`.env` に以下を設定します(リポジトリには含まれません):

```
CLIENT_ID=your_spotify_client_id
CLIENT_SECRET=your_spotify_client_secret
PLAYLIST_ID=your_playlist_id
SPOTIFY_REFRESH_TOKEN=your_refresh_token
SPOTIFY_USER_ID=your_spotify_user_id
```

## 実行

```bash
bin/update_playlist
```

## Refresh Tokenの再取得

Spotifyのrefresh tokenが失効した場合(`Refresh token revoked`エラー)、`bin/authorize` を実行して再認証します。

```bash
bin/authorize
```

案内される認可URLをブラウザで開いて許可し、リダイレクト先のURL(接続エラーになりますが問題ありません)をコピーしてスクリプトに貼り付けると、新しいrefresh tokenが表示されます。

事前にSpotify Developer DashboardのRedirect URIsに `https://127.0.0.1:3000/auth/spotify/callback` を登録しておく必要があります(HTTPでの登録はSpotify側で許可されていません)。

取得後、GitHub Secretsの `SPOTIFY_REFRESH_TOKEN` と `SPOTIFY_USER_ID` を更新してください(`bin/authorize` から直接更新することもできます)。

## GitHub Actionsでの手動実行

```bash
gh workflow run update_playlist.yml
```

## 構成

```
bin/update_playlist   # プレイリスト更新の本体
bin/authorize          # Refresh Token再取得
.github/workflows/update_playlist.yml
```
