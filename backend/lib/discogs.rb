require './waf.rb'
require 'csv'

@wrapper = Discogs::Wrapper.new("My awesome web app")

def search1 (row)
  @search_num = 1
  @wrapper.search_multiple( nil,
                           :type=> :release,
                           :title => @album_name + " " + @artist,
                           :release_title => @album_name,
                           :artist => @artist,
                           :label => row['record_label'],
                           :genre => row['genres'],
                           :year => row['release_date'].year)
end

# def search1 (row)
#   @search_num = 1
#   @wrapper.search_multiple( nil,
#                            :type=> :release,
#                            :release_title => @album_name,
#                            :artist => @artist,
#                            :label => row['record_label'],
#                            :genre => row['genres'],
#                            :year => row['release_date'].year)
# end

def search2 (row)
  @search_num = 2
  puts "!!!!Search2::" + @album_name
  @wrapper.search_multiple( nil,
                           :type=> :release,
                           :release_title => @album_name,
                           :artist => @artist,
                           :label => row['record_label'],
                           :year => row['release_date'].year)
end
def search3 (row)
  @search_num = 4
  puts "!!!!Search4::" + @album_name
  @wrapper.search_multiple( @album_name + "~",
                           :type=> :release,
                           :artist => @artist,
                           :label => row['record_label'],
                           :genre => row['genres'],
                           :year => row['release_date'].year)
end

def search4 (row)
  @search_num = 3
  puts "!!!!Search3::" + @album_name
  @wrapper.search_multiple( nil,
                           :type=> :release,
                           :release_title => @album_name,
                           :artist => @artist,
                           :year => row['release_date'].year)
end


def search5 (row)
  @search_num = 5
  puts "!!!!Search5::" + @album_name
  @wrapper.search_multiple( @album_name + "~",
                           :type=> :release,
                           :artist => @artist,
                           :label => row['record_label'])
end

def search6 (row)
  @search_num = 6
  puts "!!!!Search6::" + @album_name
  @wrapper.search_multiple( @album_name + "~",
                           :type=> :release,
                           :artist => @artist)
end

CSV.open("test_discogs_search4.csv", "wb") do |csv|
  csv << ["album_name", "release.title", "artist", "release.artists[0].name", "search#"]
end

i=0
Waf.db.query("SELECT * FROM metacritic").each do |row|
  @album_name = row['album_name']
  @artist     = row['artist']
  ap row['release_date'].year
  @artist.gsub!(/-/, ' ')
  @album_name.gsub!(/-/, ' ')
  # next unless album_name.include? "200 tons"
  ap @album_name
  search = search1(row)
  search = search2(row) if search == []
  search = search3(row) if search == []
  search = search4(row) if search == []
  search = search5(row) if search == []
  search = search6(row) if search == []

  if search == []
    CSV.open("test_discogs_search4.csv", "a+") do |csv|
      csv << [@album_name, "!", @artist, "!", "!"]
    end
    next
  end

  release = @wrapper.get_release(search[0]['id'])

  CSV.open("test_discogs_search4.csv", "a+") do |csv|
    csv << [@album_name, release.title, @artist, release.artists[0].name, @search_num]
  end

  ap release.title
  ap @artist
  ap release.artists[0].name

  i += 1
  break if i > 300
end
