class IndeedCrawl
  def initialize(harvester_url, selector_id, search_query, location)
    @harvester_url = harvester_url
    @selector_id = selector_id
    @search_query = search_query
    @location = location
  end

  # Crawl Indeed
  def run
   cm_hash = {crawler_manager_url: @harvester_url,
              selector_id: @selector_id}
   Thread.new do
     Headless.ly do
       i = IndeedCrawler.new(@search_query, @location, ENV['PROXYLIST'], [0.2, 0.3], 1, cm_hash)
       i.collect_it_all
     end
   end
  end
end
