module ApiCalls
  def get_total_docs(index_name)
    http = Curl.get("http://localhost:3000/get_total_docs", {:index_name => index_name})
    return JSON.parse(http.body_str)
  end

  def get_collection_count(collection, index_name)
    http = Curl.get("http://localhost:3000/get_collection_doc_total", {
                      :index_name => index_name,
                      :collection => collection})
    return JSON.parse(http.body_str)
  end
  
  def add_items(index_name, doc_type, items)
    c = Curl::Easy.new("http://localhost:3000/add_items")
    c.http_post(Curl::PostField.content("item_type", doc_type),
                Curl::PostField.content("index_name", index_name),
                Curl::PostField.content("items", items))
  end

  def remove_items(index_name, collection, selectors)
    c = Curl::Easy.new("http://localhost:3000/remove_items")
    c.http_post(Curl::PostField.content("collection", collection),
                Curl::PostField.content("index_name", index_name),
                Curl::PostField.content("selectors", JSON.generate(selectors)))
  end

  def get_project_spec(index_name)
    http = Curl.get("http://localhost:3000/get_project_spec", {:index_name => index_name})
    return JSON.parse(http.body_str)
  end
end
