module UpdateColselec
  include SaveColselec
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
  def update_selectors
    # Add new terms
    created_terms = gen_new_terms(@new_selectors)
    associate_terms_with_dataset(@dataset, created_terms)

    # Update existing selectors
    @updated_selectors.each do |selector|
      Term.find(selector[:id]).update_attributes(selector)
    end
  end
end
