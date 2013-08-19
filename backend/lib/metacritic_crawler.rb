require './waf.rb'

def get_meta_page()
end

def check_meta_page()
end

def next_page(num_scraped)
  # Exit if we have reached the end of the metacritic page
  exit if num_scraped == 0

  @page_num += 1
  url       = "http://www.metacritic.com/browse/albums/artist/" + @letter +"?num_items=100&page=" + @page_num.to_s
  begin
    page      = @agent.get( url )
  rescue Mechanize::ResponseCodeError => e
    sleep(30)
    puts e
    puts "Sleeping for 30 sec!"
    retry
  end

  puts "!!!!!! next page !!!!!!!___________________________"
  puts @page_num
  cycle_album_links(page)
end

# Cycle through the album links. There are only 98 per page for some reason.
# When edge is reached, will click next page and start cycling again.
#
def cycle_album_links(page)
  (1..101).each do |i|
    # Find album link, go to next page if done
    link_loc = page.at('//*[@id="main"]/div/div[1]/div[2]/div[2]/div/ol/li[' + i.to_s + ']/div/div[1]/a')
    next_page( i - 1 ) if !link_loc
    link =  Mechanize::Page::Link.new(link_loc, @agent, page)
    puts link.href

    #Can Exit now if we already have the album page
    exists =  Waf.check_metacritic_url(link.href)
    next if exists

    # Click Link to get page
    new_page = link.click

    #Check If page exists on Metacritic
    if new_page.search('span.error_code').text == '404'
      Waf.insert_error('Metacritic 404', link.href, link.href)
      puts "Metacritic Error! 404"
      next
    end
    album        = new_page.uri.to_s.split('/')[4]
    artist       = new_page.uri.to_s.split('/')[5]
    album_url    = "/music/" + album + "/" + artist
    if !new_page.link_with(:href => album_url + '/critic-reviews')
      Waf.insert_error('Metacritic 400', link.href, link.href)
      puts "Metacritic Error! 400"
      next
    end

    metacritic  = Waf::Models::Platforms::Metacritic.new(:page => new_page)
    metacritic.insert


    # Optional: For inline testing
    # Resque.inline = true

    # Build opts to pass to review model
    opts = {}
    opts[:album] = metacritic.album
    opts[:breakdown] = metacritic.breakdown

    # Loop through review links on each metacritic page. Send to Scraper!!
    metacritic.critic_pages.links_with(:text => /Read full review/).each do |review_link|
      puts review_link.href.to_s
      opts[:url] = review_link.href.to_s
      Resque.enqueue(Waf::Job::Scraper, review_link.href.to_s, opts)
    end
  end
end

@letter = "b"
@page_num = 0
starting_url = "http://www.metacritic.com/browse/albums/artist/" + @letter + "?num_items=100&page=" + @page_num.to_s
@agent       = Mechanize.new
page        = @agent.get( starting_url )
cycle_album_links(page)
