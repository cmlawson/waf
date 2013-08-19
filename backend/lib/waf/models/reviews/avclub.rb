module Waf::Models
  class Review


    class Avclub
      attr_accessor :text
      attr_accessor :album
      attr_accessor :score
      attr_accessor :parent
      attr_accessor :url

      def initialize(args = {}, opts = {})
        if args[:parent]
          @parent = args[:parent]
        else
          puts "Parent Not Given"
          # @parent = get_parent_db
        end

        if args[:avclub]
          from_site(args[:avclub], opts)
        else
          puts "Nothing here yet kjvn"
        end
      end

      def from_site(page = {}, opts = {})
        # We have a Nokogiri element for alternate encoding types
        #
        overall = page.search('div#article_wrapper p')

        # Get text and remove html elements
        # TODO: clean/find 3rd party package
        #
        a = overall.to_html(encoding: 'US-ASCII')
        a.to_s.gsub!(/<i>|<\/i>|<br>|<p>|<\/p>/, "")
        a.gsub!(/&#8220;|#8221;/, '"')
        a.gsub!(/&#8217;/, "'")

        # can't get url from Nokogiri object (I don't think)
        # we do it in the job instead
        #
        # @url = page.url.to_s
        @text = a.to_s
        @album = opts['album']
        @score = opts['breakdown']['The A.V. Club']
      end

      def get_parent_db
        # query = "SELECT *"
        # Waf.db.query()
      end

      def create()
        @parent.insert_review(@album, @url, @text, @score)
      end

    end #Class
  end #Class Review
end #Module
