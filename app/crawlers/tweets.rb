class Tweets
  def initialize(harvester_url, selector_id, search_query, search_operators)
    @search_operators = search_operators
    @search_query = search_query
    @harvester_url = harvester_url
    @selector_id = selector_id
  end

  # Crawl Twitter Search
  def run
    Thread.new do
      # Setup incremental result passing hash
      cm_hash = {crawler_manager_url: @harvester_url,
               selector_id: @selector_id}
      
      # Scrape
      t = TwitterCrawler.new(@search_query, @search_operators, cm_hash)
      t.query_tweets(nil, nil)
    end
  end
end
