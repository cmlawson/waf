module Waf::Models
  class Review


    class Pitchfork
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

        if args[:pitchfork]
          from_site(args[:pitchfork], opts)
        else
          puts "Nothing here yet fgjn"
        end
      end

      def from_site(page = {}, opts = {})
        @text = ""
        overall = page.search('div.editorial p')
        overall.each do |paragraph|
          @text += paragraph.text
        end
        @url = opts['url']
        @album = opts['album']
        @score = opts['breakdown']['Pitchfork']
      end

      def create()
        @parent.insert_review(@album, @url, @text, @score)
      end

    end #Class Popmatters
  end #Class Review
end #Module
