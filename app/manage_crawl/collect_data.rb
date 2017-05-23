module CollectData
  include RecrawlTime
  include SaveData
  include CrawlerManager

  @queue = :collect

  def self.perform(source, dataset, selector_list)
    dataset = Dataset.find(dataset["_id"])
    selector_list = selector_list.map{|s| Term.find(s["_id"])}
    loop_and_run(source, dataset, selector_list)
  end
  
  # Loop through all terms and run
  def loop_and_run(source, dataset, selector_list)
    selector_list.each do |selector|
      scrape_selector(selector, source, dataset) unless selector.recrawl_frequency == "never"
    end
  end
  
  # Scrape the selector
  def scrape_selector(selector, source, dataset)
    # Get term info
    term_query = selector[:term_query]
    query = gen_query_request(term_query, source, selector.overall_tag)
    
    # Send query and update time
    crawl(*query)
    update_recrawl_time(selector)
  end


  # Generate request with params and crawler info
  def gen_query_request(query, source, selector_tag)
    @input_params = JSON.parse(get_crawler_info(source))["input_params"]
    
    # Add all params for dataset
    input_queries = @input_params.inject({}) do |param_arr, param|
      param_arr[param[0]] = query[param[0]]
      param_arr
    end
    
    return ["#{source}_#{selector_tag}", source, input_queries]
  end
end
