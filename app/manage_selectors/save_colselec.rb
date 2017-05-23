module SaveColselec
  include SaveData
  
  # Just save dataset
  def save_dataset(dataset_params)
    # Setup dataset
    dataset_params = add_collection_tags(dataset_params)
    dataset_params["input_query_fields"] = dataset_params["input_query_fields"].to_hash
    @dataset = Dataset.new(dataset_params)

    # Process selector file
    process_selector_file if params["dataset"]["selector_file"]

    # Setup selectors
    setup_selectors(@dataset.input_query_fields)
  end

  # Add collection name tag
  def add_collection_tags(dataset_params)
    return dataset_params.merge({collection_tag: dataset_params["name"]})
  end

  # Generates a selector name for tracking in LG index
  def gen_selector_name(term_query)
    return term_query.inject(""){|str, k| str+=k[1]+" " if k[1]}.strip
  end

  # Turn a file of selectors into the same format as input_query_fields
  def process_selector_file
    # Get array of hashes
    selector_file_params = JSON.parse(File.read(params["dataset"]["selector_file"].path))
    outhash = Hash.new

    # Turn into numbered hash
    count = 0
    selector_file_params.each do |s|
      outhash[count.to_s] = s
      count += 1
    end

    @dataset.update_attributes(input_query_fields: outhash)

    return outhash
  end

  # Generate selectors for dataset
  def setup_selectors(selector_hash)
    created_terms = gen_new_terms(selector_hash)
    @dataset.save
    associate_terms_with_dataset(@dataset, created_terms)
  end

  # Creates a new term for each item in list
  def gen_new_terms(term_list)
    all_terms = Array.new

    # Make new term for each search term
    term_list.each do |k, v|
      overall_tag = gen_selector_name(v) + " ("+@dataset.name+")"
      selector_tags = {collection_tag: @dataset.name, selector_tag: gen_selector_name(v), overall_tag: overall_tag}
      all_terms.push(Term.create({term_query: v, selector_num: k}.merge(selector_tags)))
    end
    
    # Return the created terms
    return all_terms
  end

  # Add associations for a list of terms
  def associate_terms_with_dataset(dataset, term_list)
    term_list.each do |term|
      add_association(dataset.terms, term)
    end
  end
end
