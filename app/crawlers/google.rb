class Google
  def initialize(harvester_url, selector_id, search_operators, search_query)
    @search_operators = search_operators
    @search_query = search_query
    @harvester_url = harvester_url
    @selector_id = selector_id
  end

  # Crawl Google
  def run
    Thread.new do
      # Setup incremental result passing hash
      cm_hash = {crawler_manager_url: @harvester_url,
               selector_id: @selector_id}

      Headless.ly do
        # Setup request info
        requests_google = RequestManager.new(ENV['PROXYLIST'], [1, 3], 1)
        captcha_settings = ENV['SOLVERDETAILS'] != nil ? {captcha_key: ENV['SOLVERDETAILS']} : nil

        # Scrape
        g = GeneralScraper.new(@search_operators, @search_query, requests_google, captcha_settings, cm_hash)
        g.getData
      end
    end
  end
end
