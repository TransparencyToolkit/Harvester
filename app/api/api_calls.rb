module ApiCalls
  def add_items(index_name, doc_type, items)
    c = Curl::Easy.new("http://localhost:3000/add_items")
    c.http_post(Curl::PostField.content("item_type", doc_type),
                Curl::PostField.content("index_name", index_name),
                Curl::PostField.content("items", items))
  end
end
