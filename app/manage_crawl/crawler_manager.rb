module CrawlerManager
  # Process input to API and call appropriate crawler
  def crawl(selector_tag, crawler, query_params)
    # Match up with Harvester instance and object
    @crawler = find_crawler(crawler)
    harvester_path = "localhost:"+Rails::Server.new.options[:Port].to_s
    
    # Get list of parameters to pass to crawler (in correct order)
    params_for_crawler = [harvester_path, selector_tag]
    @crawler.input_params.each do |input_param|
      params_for_crawler.push(query_params[input_param[0]])
    end
    
    # Initialize new crawler and run
    c = Module.const_get(@crawler.classname).new(*params_for_crawler)
    c.run
    move_pics

    return JSON.pretty_generate(@crawler.attributes)
  end

  # Get the info for specific parser
  def get_crawler_info(crawler_class)
    return JSON.pretty_generate(find_crawler(crawler_class).attributes)
  end

  # List all available parsers
  def list_crawlers
    crawler_list = Crawler.all.inject([]) {|arr, c| arr << c.attributes}
    return JSON.pretty_generate(crawler_list)
  end
  
  # Handle pictures
  def move_pics
    create_overall_data_dir
    pic_dir = create_next_level_dir("All_Pics")
    `mv pictures/* #{pic_dir}`
    `rm -r pictures`
  end

  # Find the matching parser
  def find_crawler(crawler_class)
    @crawler = Crawler.find_by(classname: crawler_class)
  end
end
