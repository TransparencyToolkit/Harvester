module SaveData
  include IndexData

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
    output_fields = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+source).body_str)["output_fields"]
    output_fields.each do |field|
      item_hash[field] = dataitem[field]
    end

    return item_hash
  end

  # Add has_many association between two objects both ways
  def add_association(field1, item2)
    field1 << item2
  end
  
  # Save folders of data files
  def save_data_files(dataset_name, source, print_data, out_file_name)
    # Create the overall directory
    base_path = "#{Dir.pwd}/../#{ENV['PROJECT_INDEX']}/"
    Dir.mkdir(base_path) unless File.directory?(base_path)
    
    # Create results directory with name based on dataset
    results_dir = base_path+dataset_name.gsub(" ", "_").gsub("/", "-")+"_"+source+"/"
    Dir.mkdir(results_dir) unless File.directory?(results_dir)

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
