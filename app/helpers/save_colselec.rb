module SaveColselec
  # Just save dataset
  def save_dataset(dataset_params)
    # Setup dataset
    dataset_params = add_collection_tags(dataset_params)
    @dataset = Dataset.new(dataset_params)

    # Process selector file
    process_selector_file if params["dataset"]["selector_file"]

    # Setup selectors
    setup_selectors(@dataset.input_query_fields)
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
      all_terms.push(Term.create({term_query: v, selector_num: k}.merge(add_selector_tags(v))))
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
