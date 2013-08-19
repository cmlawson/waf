module Waf::Models
  class Review


    class Popmatters
      attr_accessor :text
      attr_accessor :url
      attr_accessor :album
      attr_accessor :score

      def initialize(args = {}, opts = {})
        if args[:popmatters]
          from_site(args[:popmatters], opts)
        else
          puts "Nothing here yet kjvn"
        end

        if args[:parent]
          @parent = args[:parent]
        else
          puts "Parent Not Given"
          # @parent = get_parent_db
        end
      end

      def from_site(page = {}, opts = {})
        # We have a Noki element for alternate encoding types
        #
        overall = page.search('div.ArticleContentContainer p')

        @text = ""
        overall.each do |paragraph|
          # Get text and remove html elements
          # TODO: clean/find 3rd party package
          #
          a = paragraph.to_html(encoding: 'US-ASCII')
          a.to_s.gsub!(/<i>|<\/i>|<br>|<p>|<\/p>/, "")
          a.gsub!(/&#8220;|#8221;/, '"')
          a.gsub!(/&#8217;/, "'")

          @text += a.to_s
        end
        # can't get url from Nokogiri object (I don't think)
        # we do it in the job instead
        #
        # @url = page.url.to_s
        @album = opts['album']
        @score = opts['breakdown']['PopMatters']
      end

      def create()
        @parent.insert_review(@album, @url, @text, @score)
      end

    end #Class Popmatters
  end #Class Review
end #Module
