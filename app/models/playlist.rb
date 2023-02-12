class Playlist < ApplicationRecord
  def self.scrape
    agent = Mechanize.new
    page = agent.get('https://www.fmnorth.co.jp/hot100/')
    page.search('.hot100List').each do |table|
      table.search('.hot100List__detail').each do |row|
        track = row.at('.musicTitle').text.squish
        artist = row.at('.hot100List__detail--artist').text
        record = self.create(track: track, artist: artist)
      end
    end
  end
end
