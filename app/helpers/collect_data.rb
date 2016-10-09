module CollectData
  include RecrawlTime
  include SaveData

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
    query = gen_query_url(term_query, source, selector.overall_tag)

    # Send query and update time
    Curl.get(query)
    update_recrawl_time(selector)
  end


  # Generate URL with params and crawler info
  def gen_query_url(query, source, selector_tag)
    @input_params = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+source).body_str)["input_params"]

    # Gen url base
    url = "http://0.0.0.0:9506/crawlers?"
    url += "crawler="+source
    url += "&selector-tag="+Base64.encode64(source+"_"+selector_tag).strip.gsub(/\n/, '')
    url += "&harvester-path="+Base64.encode64("127.0.0.1:"+Rails::Server.new.options[:Port].to_s).strip

    # Add all params for dataset
    @input_params.each do |param, type|
      par = query[param] ? Base64.encode64(query[param]).strip.gsub(/\n/, '') : ""
      url += "&"+param+"="+par
    end
    
    return url
  end
end
