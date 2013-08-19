class Waf::Job::Scraper::Popmatters
  # include Sidekiq::Worker
  @queue = :test

  def self.perform(url, opts = {})
    begin
      # We use Nokogiri for this one, because of alternate
      # encoding types
      #
      page = Nokogiri::HTML(open("" + url.to_s + ""))
    rescue Timeout::Error => e
      puts e
      Waf.insert_error(e, url, opts['album'])
      return
    rescue SocketError => e
      puts e
      Waf.insert_error(e, url, opts['album'])
      return
    rescue Net::HTTP::Persistent::Error => e
      puts e
      Waf.insert_error(e, url, opts['album'])
      return
    rescue Errno::ETIMEDOUT => e
      puts e
      Waf.insert_error(e, url, opts['album'])
      return
    rescue OpenURI::HTTPError => e
      puts e
      Waf.insert_error(e, url, opts['album'])
      return
    end
    review  = Waf::Models::Review.new({:popmatters => page}, opts)
    review.popmatters.url = url.to_s # We do this because Nokogiri doesn't give full urls in model
    review.create
  end
end
