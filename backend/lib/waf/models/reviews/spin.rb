module Waf::Models
  class Review


    class Spin
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

        if args[:spin]
          from_site(args[:spin], opts)
        else
          puts "Nothing here yet kjvn"
        end
      end

      def from_site(page = {}, opts = {})
        overall = page.search('article div section.main.cms_styles p')

        @text = ""
        overall.each do |paragraph|
          @text += paragraph.text.to_s
        end

        @url = opts['url']
        @album = opts['album']
        @score = opts['breakdown']['Spin']
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
