class Waf::Job::Scraper::Ew
  # include Sidekiq::Worker
  @queue = :test

  def self.perform(url, opts = {})
    agent       = Mechanize.new
    begin
      page        = agent.get( url )
    rescue Mechanize::ResponseCodeError => e
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
      Waf.insert_error(e, url, opts['album'])
      puts e
      return
    end
    ew  = Waf::Models::Review.new({:ew => page}, opts)
    ew.create
  end
end
