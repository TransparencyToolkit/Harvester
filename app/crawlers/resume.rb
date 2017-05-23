class Resume
  def initialize(harvester_url, selector_id, search_query)
    @search_query = search_query
    @harvester_url = harvester_url
    @selector_id = selector_id
  end

  # Crawl LinkedIn
  def run
    Thread.new do
      # Setup incremental result passing hash
      cm_hash = {crawler_manager_url: @harvester_url,
                 selector_id: @selector_id}

      requests_linkedin = RequestManager.new(ENV['PROXYLIST'], [1, 3], 1)
#      Headless.ly do
        # Setup request info 
        requests_google = RequestManager.new(ENV['PROXYLIST'], [10, 30], 1)
        requests_google2 = RequestManager.new(ENV['PROXYLIST'], [10, 30], 1)
        captcha_settings = ENV['SOLVERDETAILS'] != nil ? {captcha_key: ENV['SOLVERDETAILS']} : nil

        # Scrape
        c = LinkedinCrawler.new(@search_query, 1, requests_linkedin, requests_google, requests_google2, captcha_settings, cm_hash)
        c.search
 #     end
    end
  end
end
