module Waf

  require 'resque'
  require 'sidekiq'
  require 'redis'
  require 'musicbrainz'
  require 'mysql2'
  require 'rubygems'
  require 'net/ssh/gateway'
  require 'mechanize'
  require 'sanitize'
  require 'awesome_print'
  require 'json'
  require 'open-uri'
  require 'hpricot'
  require 'require_all'

  require_rel 'waf'

  $redis = Redis.connect

  MusicBrainz.configure do |c|
    # Application identity (required)
    c.app_name = "Which Album First"
    c.app_version = "1.0"
    c.contact = "info@whichalbumfirst.com"

    # Cache config (optional)
    c.cache_path = "/tmp/musicbrainz-cache"
    c.perform_caching = true

    # Querying config (optional)
    c.query_interval = 1.2 # seconds
    c.tries_limit = 3
  end

  remote = false

  if remote
    host = '127.0.0.1'
    username = "whiccleu_colin"
    port = 3306
    password = 'Spotistic8'
  else
    host = 'localhost'
    username = "root"
    password = 'Spotistic8'
  end

  # Initiate mysql connection
  #
  @db = Mysql2::Client.new(:host     => host,
                           :username => username,
                           :password => password)
  @db.query("USE test")

  def self.db
    @db
  end

  def self.check_metacritic_url (url)
    query =  ""
    query += "SELECT count(*) AS counter FROM metacritic Where album_url ='"
    query += url
    query += "'"
    result = @db.query(query).map{|a| a['counter'] == 1}
    return result.pop
  end

  def self.check_review_url (url)
    query =  ""
    query += "SELECT count(*) AS counter FROM reviews Where website ='"
    query += url
    query += "'"
    result = @db.query(query).map{|a| a['counter'] == 1}
    puts "skipped input url"
    puts url
    return result.pop
  end

  def self.insert_review(album,source,text,rating)
    insert  =  "INSERT INTO reviews VALUES ('"
    insert +=  Waf.db.escape(album)
    insert += "','"
    insert +=  Waf.db.escape(source)
    insert += "','"
    insert +=  Waf.db.escape(text)
    insert += "','"
    insert +=  rating.to_s
    insert += "')"

    @db.query(insert)
  end

  def self.insert_error(e, url, album)
    insert  =  "INSERT INTO errors VALUES ('"
    insert +=  Waf.db.escape(e.to_s)
    insert += "','"
    insert +=  Waf.db.escape(url)
    insert += "','"
    insert +=  Waf.db.escape(album)
    insert += "')"

    @db.query(insert)
  end

  # results = @db.query("SELECT * FROM reviews")

  # results.each do |row|
  #   puts row['album_name']
  # end

end
