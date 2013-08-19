module Waf::Models
  class Review


    class Allmusic
      attr_accessor :text
      attr_accessor :album
      attr_accessor :score
      attr_accessor :parent

      def initialize(args = {}, opts = {})
        if args[:parent]
          @parent = args[:parent]
        else
          puts "Parent Not Given"
          # @parent = get_parent_db
        end

        if args[:allmusic]
          from_site(args[:allmusic], opts)
        else
          puts "Nothing here yet kjvn"
        end
      end

      def from_site(page = {}, opts = {})
        @text = ""
        overall = page.search('section.review.read-more div.text p')
        overall.each do |paragraph|
          @text += paragraph.content
        end
        @url   = opts['url']
        @album = opts['album']
        @score = opts['breakdown']['All Music Guide']
      end

      def get_parent_db
        # query = "SELECT *"
        # Waf.db.query()
      end


      def create()
        @parent.insert_review(@album, @url, @text, @score)
      end

    end #Class Popmatters
  end #Class Review
end #Module
