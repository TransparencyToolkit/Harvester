module DatasetsHelper
  # Get count of all results
  def get_overall_count
    #TODO: Will need to modify this to work with domains!
    return Dataitem.distinct(:matching_id).length
  end

  # Get number of results for single dataset
  def get_count_per_dataset(dataset)
    return dataset.dataitems.distinct(:matching_id).length
  end

  # Generate JSON with all data to print on show view
  def gen_print_data(dataset)
    result_data = dataset.dataitems.inject([]) do |all_items, item|
      all_items.push(Dataitem.find(item).as_json)
    end
    result_data
  end

  # Generate a label for the checkbox
  def gen_checkbox_label(selector)
    label = ""
    selector.term_query.each do |query, value|
      label += value.to_s+" "
    end

    label += " (Last Collected:"+selector.latest_collection_time.to_s+")"
    return label
  end

  # Generate default value for recrawl frequency
  def gen_recrawl_freq_val
    if @dataset.recrawl_frequency
      return @dataset.recrawl_frequency
    else
      return "1"
    end
  end

  # See if the button should be checked for recrawl interval
  def check_recrawl_interval?(interval)
    # Check current val
    if @dataset.recrawl_interval == interval
      return true

    # Default to once if no val
    elsif !@dataset.recrawl_interval && interval == 'once'
      return true
    else
      return false
    end
  end
end
