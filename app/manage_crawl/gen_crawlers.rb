load "app/api/api_calls.rb"
load 'app/models/crawler.rb'
include ApiCalls

# Generate crawlers from the dataspec file
module GenCrawlers
  # Loop through and generate all the crawlers for the project
  def gen_all_crawlers
    # Clear out old crawler list
    Crawler.delete_all

    # Generate new crawlwers from spec
    project_spec = get_project_spec(ENV["PROJECT_INDEX"])
    project_spec["datasources"].each do |source|
      create_new_crawler(source)
    end
  end

  # Create a new crawler
  def create_new_crawler(source)
    if !source["input_params"].blank?
      Crawler.create( name: source["name"],
                      description: source["description"],
                      icon: source["icon"],
                      classname: source["class_name"],
                      input_params: source["input_params"],
                      output_fields: source["source_fields"].symbolize_keys.keys)
    end
  end
end
