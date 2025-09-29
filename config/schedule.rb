# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Learn more: http://github.com/javan/whenever

set :environment, "production"
set :output, "/Users/m.kawamura/work/sapporo-hot100/log/cron.log"

# 日曜日の17:00にプレイリスト更新
every :sunday, at: '5:00 pm' do
  rake "playlist:update"
end