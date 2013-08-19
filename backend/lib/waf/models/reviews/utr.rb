module Waf::Models
  class Review


    class Utr
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

        if args[:utr]
          from_site(args[:utr], opts)
        else
          puts "Nothing here yet kjvn"
        end
      end

      def from_site(page = {}, opts = {})
        overall = page.search('//*[@id="main"]/p')

        @text = ""
        overall.each do |paragraph|
          @text += paragraph.text.to_s.split.join(" ")
        end

        @url = opts['url']
        @album = opts['album']
        @score = opts['breakdown']['Under The Radar']
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
