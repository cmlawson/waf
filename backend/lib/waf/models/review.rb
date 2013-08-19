module Waf::Models
  class Review
    attr_accessor :parent
    attr_accessor :popmatters
    attr_accessor :allmusic
    attr_accessor :pitchfork
    attr_accessor :newmusicexpress
    attr_accessor :rollingstone
    attr_accessor :avclub
    attr_accessor :spin
    attr_accessor :utr
    attr_accessor :ew



    def initialize(args = {}, opts = {})
      if args[:popmatters]
        @popmatters = Popmatters.new({:popmatters => args[:popmatters], :parent => self}, opts)
      elsif args[:allmusic]
        @allmusic = Allmusic.new({:allmusic => args[:allmusic], :parent => self}, opts)
      elsif args[:pitchfork]
        @pitchfork = Pitchfork.new({:pitchfork => args[:pitchfork], :parent => self}, opts)
      elsif args[:nme]
        @nme = Nme.new({:nme => args[:nme], :parent => self}, opts)
      elsif args[:rollingstone]
        @rollingstone = Rollingstone.new({:rollingstone => args[:rollingstone], :parent => self}, opts)
      elsif args[:avclub]
        @avclub = Avclub.new({:avclub => args[:avclub], :parent => self}, opts)
      elsif args[:spin]
        @spin = Spin.new({:spin => args[:spin], :parent => self}, opts)
      elsif args[:utr]
        @utr = Utr.new({:utr => args[:utr], :parent => self}, opts)
      elsif args[:ew]
        @ew = Ew.new({:ew => args[:ew], :parent => self}, opts)
      elsif args[:cmg]
        @cmg = Cmg.new({:cmg => args[:cmg], :parent => self}, opts)
      else
        puts "Don't have this platform mapped yet"
      end
    end

    def create()
      @allmusic.create        if @allmusic
      @pitchfork.create       if @pitchfork
      @popmatters.create      if @popmatters
      @newmusicexpress.create if @newmusicexpress
      @rollingstone.create    if @rollingstone
      @avclub.create          if @avclub
      @spin.create            if @spin
      @utr.create             if @utr
      @ew.create              if @ew
    end

    def insert_review(album,source,text,rating)
      insert  =  "INSERT INTO reviews VALUES ('"
      insert +=  Waf.db.escape(album)
      insert += "','"
      insert +=  Waf.db.escape(source)
      insert += "','"
      insert +=  Waf.db.escape(text)
      insert += "','"
      insert +=  rating.to_s
      insert += "')"

      Waf.db.query(insert)
    end

  end #Class Review
end #Module Waf::Models
