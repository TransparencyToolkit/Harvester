module IndexData
  # Remove iterms from elasticsearch
  def remove_item_elastic(data)
    if !data.empty? # Ony delete if something to delete
      # Get info needed
      source = data.first.dataset.source
      gen_dataspec(source)
      extract_arr = JSON.pretty_generate(gen_extract_arr(data, source))

      # Send request
      c = Curl::Easy.new("http://localhost:3000/remove_item")
      c.http_post(Curl::PostField.content("source", source), Curl::PostField.content("extracted_items", extract_arr))
    end
  end
  
  def index_elastic(data, term, source)
    gen_dataspec(source)
    
    # Extract all items and IDs, save in hash, in arr
    extract_arr = JSON.pretty_generate(gen_extract_arr(data, source))

    # Send request
    c = Curl::Easy.new("http://localhost:3000/add_new_item")
    c.http_post(Curl::PostField.content("source", source), Curl::PostField.content("extracted_items", extract_arr))
  end

  # Generate array of extracted, preprocessed items
  def gen_extract_arr(data, source)
    extract_arr = Array.new
    data.each do |data_item|
      extracted_item, id = extract_item(data_item, source)
      extract_arr.push({item: extracted_item, id: id})
    end
    return extract_arr
  end

  # Return the item to index
  def extract_item(data_item, source)
    # Get the fields to index
    item_fields = JSON.parse(data_item.to_json).except("_id")
    id = JSON.parse(data_item.to_json)["_id"]["$oid"]

    # Get dataset name and source
    data_source = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+source).body_str)["name"]

    # Merge in fields and return
    item_fields.merge!(dataset_name: data_item.term.collection_tag)
    item_fields.merge!(search_terms: data_item.term.selector_tag)
    item_fields.merge!(overall_tag: data_item.term.overall_tag)
    item_fields.merge!(data_source: data_source)
    
    return JSON.pretty_generate(item_fields), id
  end

  def gen_dataspec(source)
    Curl.get("http://localhost:3000/find_dataspec?source="+source)
  end
end
