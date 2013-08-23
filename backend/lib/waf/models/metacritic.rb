module Waf::Models
  class Platforms

    # Public: Define the Metacritc source of information
    # and retrieve data from either the website or the database
    # All methods are class methods and should be called on the
    # Metacritic class.
    #
    # Examples
    #   metacritic = Metacritic.new(:page => page)
    #   metacritic.XXX
    #   # => XXX
    class Metacritic

      attr_accessor :page
      attr_accessor :album
      attr_accessor :artist
      attr_accessor :album_url
      attr_accessor :metascore
      attr_accessor :userscore
      attr_accessor :num_critics
      attr_accessor :num_users
      attr_accessor :record_label
      attr_accessor :genres
      attr_accessor :release_date
      attr_accessor :critic_pages
      attr_accessor :breakdown
      attr_accessor :review_urls

      def initialize (args = {}, opts = {})
        if @page = args[:page]
          from_site()
        else
          puts "Nothing Here Yet!"
          # TODO: Code query from database
        end
      end

      def from_site()
        @album        = @page.uri.to_s.split('/')[4]
        @artist       = @page.uri.to_s.split('/')[5]
        @album_url    = "/music/" + @album + "/" + @artist
        @metascore    = get_metascore()
        @userscore    = get_userscore()
        @num_critics  = get_num_critics()
        @num_users    = get_num_users()
        @record_label = get_record_label()
        @genres       = get_genres()
        @release_date = get_release_date()
        @critic_pages = get_critic_page()
        @breakdown    = get_breakdown()
        @review_urls  = get_review_urls()
      end

      def to_hash()
        h = {}
        h[:album]        =  @album
        h[:artist]       =  @artist
        h[:album_url]    =  @album_url
        h[:metascore]    =  @metascore
        h[:userscore]    =  @userscore
        h[:num_critics]  =  @num_critics
        h[:num_users]    =  @num_users
        h[:record_label] =  @record_label
        h[:genres]       =  @genres
        h[:release_date] =  @release_date
        h[:breakdown   ] =  @breakdown
        h[:review_urls ] =  @review_urls
        h
      end

      def to_mysql()
        insert  =  "INSERT IGNORE INTO metacritic VALUES ("
        insert += "'"
        insert +=  Waf.db.escape(@album)
        insert += "','"
        insert +=  Waf.db.escape(@artist)
        insert += "','"
        insert +=  Waf.db.escape(@album_url)
        insert += "','"
        insert +=  @metascore.to_s
        insert += "','"
        insert +=  @userscore.to_s
        insert += "','"
        insert +=  @num_critics.to_s
        insert += "','"
        insert +=  @num_users.to_s
        insert += "','"
        insert +=  Waf.db.escape(@record_label)
        insert += "','"
        insert +=  Waf.db.escape((@genres||['none'])*",")
        insert += "','"
        insert +=  @release_date.to_s
        insert += "','"
        insert +=  Waf.db.escape(@breakdown.to_json)    # JSON.parse()
        insert += "','"
        insert +=  Waf.db.escape(@review_urls.to_json)    # JSON.parse()
        insert += "')"
        return insert
      end

      def insert()
        insert = to_mysql()
        Waf.db.query(insert)
      end

      def get_critic_page()
        critic_reviews = page.link_with(:href => album_url + '/critic-reviews').click
        critic_reviews = critic_reviews.link_with(:href => album_url + '/critic-reviews?sort-by=most-active').click
        return critic_reviews
      end

      def get_reviews()
        puts  "DEPRACATED: We use a job instead of a model method now!"
      end

      # All the private functions, called within the model
      # primarily used to scrape the actual data
      #
      private
      def get_metascore()
        info = @page.search("div.data.metascore span").
                         select{|link| link['class'] == 'score_value'}
        return nil if !info[0]
        return info[0].text.to_i
      end

      def get_userscore()
        info = @page.search("div.data.avguserscore span").
                         select{|link| link['class'] == 'score_value'}
        return nil if !info[0]
        return info[0].text.to_f
      end

      def get_num_critics()
        info = @page.search("div.metascore_wrap div.summary p span.count a span")
        return nil if !info[0]
        return info[0].text.to_i
      end

      def get_num_users()
        info = @page.search("div.userscore_wrap div.summary p span.count a")
        return nil if !info[0]
        return info[0].text.to_i
      end

      def get_record_label()
        info = @page.search('//*[@id="main"]/div[3]/div/div[2]/div[2]/div[2]/ul/li[1]/span[2]')
        return nil if !info[0]
        return info[0].text
      end

      def get_genres()
        info = @page.search('//*[@id="main"]/div[3]/div/div[2]/div[2]/div[2]/ul/li[2]/span[2]')
        return nil if !info[0]
        genres = []
        info[0].text.split(',').each do |genre|
          genres << genre.strip
        end
        return genres
        # return genres*","
      end

      def get_release_date()
        info = @page.search('//*[@id="main"]/div[1]/div[3]/ul/li[3]/span[2]')
        return nil if !info[0]
        return nil if info[0].text == ""
        return Date.parse(info[0].text)
      end

      # Cycle through review summaries and take score and source
      #
      def get_breakdown()
        info = @critic_pages.search("ol.reviews.critic_reviews div.review_stats")
        rating = {}
        info.each do |review|
          rating[review.search("div.review_critic div.source").text] = review.search("div.review_grade.critscore").text.to_i
          # breakdown << rating
        end
        return rating
      end

      # Cycle through review urls and add to @review_urls
      #
      def get_review_urls()
        urls = []
        @critic_pages.links_with(:text => /Read full review/).each do |review_link|
          urls << review_link.href.to_s
        end
        return urls
      end

    end #Class Metacritic
  end#Class Platforms
end #module Waf::Models
