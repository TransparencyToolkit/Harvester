module SaveData
  include IndexData
  include CrawlerManager

  @queue = :save

  def self.perform(results, dataset, term, source, out_file_name)
    save_data(results, dataset, term, source, out_file_name)
  end

  # Save all data
  def save_data(results, dataset, term, source, out_file_name)
    term = Term.find(term["_id"])
    dataset = Dataset.find(dataset["_id"])
    
    results_to_index = Array.new
    results.each do |dataitem|
      # Create item for appropriate model
      item_values = gen_params_hash(dataitem, source)
   
      # Set collection time
      item_values.merge!(collection_time: Time.now)

      # Push to array to index
      results_to_index.push(item_values)
      save_data_files(dataset.name, source, JSON.pretty_generate([dataitem]), out_file_name)
    end
    
    # Add collection time to term, index term, and save
    term.update_attributes(latest_collection_time: Time.now)
    index_elastic(results_to_index, term, source, nil)
  end
                                              
  # Generate parameters hash
  def gen_params_hash(dataitem, source)
    item_hash = Hash.new
    output_fields = JSON.parse(get_crawler_info(source))["output_fields"]
    output_fields.each do |field|
      item_hash[field] = dataitem[field]
    end

    return item_hash
  end

  # Add has_many association between two objects both ways
  def add_association(field1, item2)
    field1 << item2
  end

  # Create the top level dir for storing data
  def create_overall_data_dir
    base_path = "#{Dir.pwd}/../#{ENV['PROJECT_INDEX']}/"
    Dir.mkdir(base_path) unless File.directory?(base_path)
  end

  # Create the next directory down
  def create_next_level_dir(folder_name)
    base_path = "#{Dir.pwd}/../#{ENV['PROJECT_INDEX']}/"
    results_dir = base_path+folder_name
    Dir.mkdir(results_dir) unless File.directory?(results_dir)
    return results_dir
  end
  
  # Save folders of data files
  def save_data_files(dataset_name, source, print_data, out_file_name)
    # Create the overall directory and results dir
    create_overall_data_dir
    results_dir = create_next_level_dir("#{dataset_name.gsub(" ", "_").gsub("/", "-")}_#{source}/")

    # Set output filename based on output and timestamp
    filename = results_dir+out_file_name+Time.now.to_s.gsub(":", "").gsub(" ", "_")+rand(5000).to_s+".json"
    File.write(filename, print_data)
  end

  # Generate value string name for files
  def val_string(value)
    value_str = ""
    value.each do |k, v|
      value_str += v.gsub(" ", "_").gsub("/", "_").gsub(":", "")+"_"
    end
    return value_str
  end
end
