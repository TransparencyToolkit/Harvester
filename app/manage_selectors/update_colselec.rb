module UpdateColselec
  include SaveColselec
  include ScheduleRecrawl
  def find_updated_selectors(dataset_params)
    @updated_selectors = Array.new

    # Add all changed items to updated_items
    @dataset.terms.each do |selector|
      updated_selector = dataset_params["input_query_fields"][selector.selector_num]
      if selector.term_query != updated_selector
        @updated_selectors.push({term_query: updated_selector, selector_num: selector.selector_num, id: selector.id})
      end
    end

    # Add all additional selectors to new
    max_count = @dataset.terms.count-1
    @new_selectors = dataset_params["input_query_fields"].select{|k,v| k.to_i > max_count}
  end

  # Update individual selectors
  def update_selectors(recrawl_frequency, recrawl_interval)
    # Add new terms
    created_terms = gen_new_terms(@new_selectors)
    associate_terms_with_dataset(@dataset, created_terms)
    save_rescrape_info(@dataset, created_terms, recrawl_frequency, recrawl_interval)

    # Update existing selectors
    @updated_selectors.each do |selector|
      Term.find(selector[:id]).update_attributes(selector)
    end

    # Make list of all modified selectors
    @all_modified_selectors = created_terms
    @updated_selectors.each {|s| @all_modified_selectors.push(Term.find(s[:id]))}
  end
end
