module IndexData
  include ApiCalls

  # Add items to elasticsearch
  def index_elastic(data, term, source, selector)
    # Extract all items and IDs, save in hash, in arr
    extract_arr = JSON.pretty_generate(gen_extract_arr(data, source, selector, term))
    
    # Send request
    add_items(ENV['PROJECT_INDEX'], source, extract_arr)
  end

  # Generate array of extracted, preprocessed items
  def gen_extract_arr(data, source, selector, term)
    extract_arr = Array.new
    data.each do |data_item|
      # Set selector to term when nil (selector should only be passed in for single scrape)
      selector ||= term
      extracted_item = extract_item(data_item, source, selector)
      extract_arr.push(extracted_item)
    end
    return extract_arr
  end

  # Return the item to index
  def extract_item(data_item, source, selector)
    # Get the fields to index
    item_fields = JSON.parse(data_item.to_json).except("_id")

    # Get dataset name and source
    data_source = JSON.parse(get_crawler_info(source))["name"]

    # Merge in fields and return
    item_fields.merge!(collection_tag: [selector["collection_tag"]])
    item_fields.merge!(selector_tag: [selector["selector_tag"]])
    item_fields.merge!(data_source: data_source)
    
    return item_fields
  end
end
