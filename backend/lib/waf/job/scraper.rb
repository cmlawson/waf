class Waf::Job::Scraper
  # include Sidekiq::Worker
  @queue = :high

  def self.perform(url, opts = {})
    if url.to_s.include? "popmatters.com"
      Resque.enqueue(Waf::Job::Scraper::Popmatters, url, opts)
    elsif url.to_s.include? "spin.com"
      Resque.enqueue(Waf::Job::Scraper::Spin, url, opts)
    elsif url.to_s.include? "avclub"
      Resque.enqueue(Waf::Job::Scraper::Avclub, url, opts)
    elsif url.to_s.include? "nme.com"
      Resque.enqueue(Waf::Job::Scraper::Nme, url, opts)
    elsif url.to_s.include? "rollingstone"
      Resque.enqueue(Waf::Job::Scraper::Rollingstone, url, opts)
    elsif url.to_s.include? "pitchfork.com"
      Resque.enqueue(Waf::Job::Scraper::Pitchfork, url, opts)
    elsif url.to_s.include? "allmusic.com"
      Resque.enqueue(Waf::Job::Scraper::Allmusic, url, opts)
    elsif url.to_s.include? "utr"
      Resque.enqueue(Waf::Job::Scraper::Utr, url, opts)
    elsif url.to_s.include? "ew.com"
      Resque.enqueue(Waf::Job::Scraper::Ew, url, opts)
    elsif url.to_s.include? "cokemachineglow.com"
      Resque.enqueue(Waf::Job::Scraper::Cmg, url, opts)
    end
  end
end
