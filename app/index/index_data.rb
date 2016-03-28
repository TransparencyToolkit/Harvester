module IndexData
  def index_elastic(data, term, source)
    # Create index- maybe pass in source?
    gen_dataspec(source)
    data.each do |data_item|
      # Preprocess item
      extracted_item, id = extract_item(data_item, term, source)

      # Post item
      c = Curl::Easy.new("http://localhost:3000/add_new_item")
      c.http_post(Curl::PostField.content("source", source), Curl::PostField.content("extracted_item", extracted_item),
                  Curl::PostField.content("uid", id))
    end
  end

  # Return the item to index
  def extract_item(data_item, term, source)
    # Get the fields to index
    item_fields = JSON.parse(data_item.to_json)["indeed_item"].except("id")
    id = JSON.parse(data_item.to_json)["indeed_item"]["id"]

    # Get dataset name and source
    dataset_name = term.term_query.inject(""){|str, k| str+=k[1] if k[1]}
    data_source = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+source).body_str)["name"]

    # Merge in fields and return
    item_fields.merge!(dataset_name: dataset_name)
    item_fields.merge!(search_terms: dataset_name)
    item_fields.merge!(data_source: data_source)
    return JSON.pretty_generate(item_fields), id
  end

  def gen_dataspec(source)
    Curl.get("http://localhost:3000/find_dataspec?source="+source)
  end
end
