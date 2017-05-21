module DeleteSelectors
  include SaveData
  include ApiCalls
  
  @queue = :delete

  def self.perform(terms)
    terms = terms.map{|s| Term.find(s["_id"])} if terms
    delete_collection(terms)
  end
  
  # Delete from Harvester and ES
  def self.delete_collection(terms)
    delete_elastic(terms)
    delete_terms(terms) if terms
  end

  # Remove items from elasticsearch
  def self.delete_elastic(terms)
    # Get collection and selectors
    collection = terms.first.collection_tag
    selectors = terms.map{|term| term.selector_tag}

    # Remove the items from elastic
    remove_items(ENV["PROJECT_INDEX"], collection, selectors)
  end

  # Delete the terms
  def self.delete_terms(terms)
    terms.each{|d| d.delete}
  end
end
