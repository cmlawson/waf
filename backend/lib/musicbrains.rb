require './waf.rb'

i=0
Waf.db.query("SELECT * FROM metacritic").each do |row|
  album_name = row['album_name']
  artist     = row['artist']
  rg = MusicBrainz::ReleaseGroup.find_by_artist_and_title(artist, album_name, 'Album')
  if !rg
    puts artist
    puts album_name
  else
    ap rg.releases
    rg2 = MusicBrainz::ReleaseGroup.find(rg['id'])
    ap rg2
  end

  break if i>2
end
