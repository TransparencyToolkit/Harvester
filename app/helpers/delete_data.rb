module DeleteData
  # Delete from Harvester and ES
  def delete_collection(items, terms)
    delete_elastic(items)
    delete_terms(terms)
    delete_items(items)
  end

  # Remove items from elasticsearch
  def delete_elastic(items)
    i = IndexData.new
    i.remove_item_elastic(items)
  end

  # Delete the terms
  def delete_terms(terms)
    terms.each{|d| d.delete}
  end

  # Delete dataitems
  def delete_items(items)
    items.each{|z| z.delete}
  end
end
