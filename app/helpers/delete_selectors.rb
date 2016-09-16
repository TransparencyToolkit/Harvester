module DeleteSelectors
  include SaveData
  
  @queue = :delete

  def self.perform(items, terms, source, selector)
    terms = terms.map{|s| Term.find(s["_id"])} if terms
    items = items.map{|s| Dataitem.find(s["_id"])}
    delete_collection(items, terms, source, selector)
  end
  
  # Delete from Harvester and ES
  def self.delete_collection(items, terms, source, selector)
    delete_elastic(items, source, selector)
    delete_terms(terms) if terms
    delete_items(items)
  end

  # Remove items from elasticsearch
  def self.delete_elastic(items, source, selector)
    remove_item_elastic(items, source, selector)
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
