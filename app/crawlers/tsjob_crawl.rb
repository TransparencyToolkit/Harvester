class TsjobCrawl
  def initialize(harvester_url, selector_id, search_query)
    @search_query = set_query(search_query)
    @harvester_url = harvester_url
    @selector_id = selector_id
  end

  # Set the query to nil if empty
  def set_query(search_query)
    search_query.empty? ? (return nil) : (return search_query)
  end

  # Crawl Google
  def run
    Thread.new do
      # Setup incremental result passing hash
      cm_hash = {crawler_manager_url: @harvester_url,
               selector_id: @selector_id}

      Headless.ly do
        # Setup request info
        requests = RequestManager.new(ENV['PROXYLIST'], [0, 0], 1)
        
        # Scrape
        t = TSJobCrawler.new(@search_query, requests, cm_hash)
        t.crawl_jobs
      end
    end
  end
end
