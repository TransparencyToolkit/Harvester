module TagGen
  # Gen overall name
  def gen_both_tags(dataset_name, term_query)
    # Generate tags
    collection_tag = gen_collection_name(dataset_name)
    selector_tag = gen_selector_name(term_query)
    overall_tag = selector_tag + " ("+collection_tag+")"

    # Return all
    return collection_tag, selector_tag, overall_tag
  end

  # Generates a collection name for tracking in LG index 
  def gen_collection_name(dataset_name)
    return dataset_name
  end

  # Generates a selector name for tracking in LG index
  def gen_selector_name(term_query)
    return term_query.inject(""){|str, k| str+=k[1]+" " if k[1]}.strip
  end

  # Add collection name tag
  def add_collection_tags(dataset_params)
    return dataset_params.merge({collection_tag: gen_collection_name(dataset_params["name"])})
  end

  # Add selector name tag
  def add_selector_tags(term_params)
    collection_tag, selector_tag, overall_tag = gen_both_tags(@dataset.name, term_params)
    return {collection_tag: collection_tag,
            selector_tag: selector_tag,
            overall_tag: overall_tag}
  end
end
