module IndexData
  def index_elastic(data, source)
    # Create index- maybe pass in source?
    get_dataspec(source)
    data.each do |data_item|
      # Call create on each item
    end
  end

  def get_dataspec(source)
    Curl.get("http://localhost:3000/find_dataspec?source="+source)
  end
  # ACCESS CONTROL?
  
  # Append and create:
  # Calls processItem with the item and dataspec
  # Get the doc_class
  # createItem(processItem(i, dataspec), dataset_name.gsub(" ", "")+count.to_s, dataspec, doc_class)
end
