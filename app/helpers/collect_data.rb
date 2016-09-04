module CollectData
  include SaveData

  # Loop through all terms and run
  def loop_and_run(params, dataset)
    dataset.terms.each do |term|
      scrape_selector(term, params["source"], dataset)
    end
  end

  # Scrape the selector
  def scrape_selector(selector, source, dataset)
    term_query = selector[:term_query]
    query = gen_query_url(term_query, source)
    curl_url = Curl.get(query).body_str
    results = JSON.parse(curl_url)
    save_data(results, dataset, selector, source, val_string(term_query))
  end


  # Generate URL with params and crawler info
  def gen_query_url(query, source)
    @input_params = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+source).body_str)["input_params"]

    # Gen url base
    url = "http://0.0.0.0:9506/crawlers?"
    url += "crawler="+source

    # Add all params for dataset
    @input_params.each do |param, type|
      par = query[param] ? Base64.encode64(query[param]).strip : ""
      url += "&"+param+"="+par
    end

    return url
  end
end
