module Waf::Models
  class Review


    class Nme
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

        if args[:nme]
          from_site(args[:nme], opts)
        else
          puts "Nothing here yet kjvn"
        end
      end

      def from_site(page = {}, opts = {})
        @text = ""
        overall = page.search('p.article_text')
        overall.each do |paragraph|
          @text += Sanitize.clean(paragraph.inner_html).split.join(" ")
        end
        @url = opts['url']
        @album = opts['album']
        @score = opts['breakdown']['New Musical Express (NME)']
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
