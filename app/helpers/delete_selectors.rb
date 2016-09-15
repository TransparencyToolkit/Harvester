module DeleteSelectors
  include SaveData
  
  @queue = :delete

  def self.perform(items, terms, source)
    terms = terms.map{|s| Term.find(s["_id"])}
    items = items.map{|s| Dataitem.find(s["_id"])}
    delete_collection(items, terms, source)
  end
  
  # Delete from Harvester and ES
  def self.delete_collection(items, terms, source)
    delete_elastic(items, source)
    delete_terms(terms)
    delete_items(items)
  end

  # Remove items from elasticsearch
  def self.delete_elastic(items, source)
    remove_item_elastic(items, source)
  end

  # Delete the terms
  def self.delete_terms(terms)
    terms.each{|d| d.delete}
  end

  # Delete dataitems
  def self.delete_items(items)
    items.each{|z| z.delete}
  end
end
