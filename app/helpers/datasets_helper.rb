module DatasetsHelper
  # Get count of all results
  def get_overall_count
    #TODO: Will need to modify this to work with domains!
    return count_unique(Dataitem.all)
  end

  # Get number of results for single dataset
  def get_count_per_dataset(dataset)
    return count_unique(dataset.dataitems)
  end

  # Get number of items with unique ID in set
  def count_unique(items)
    id_arr = Array.new
    items.each{|i| id_arr.push(i["matching_id"]) if i["matching_id"]}
    return id_arr.uniq.length
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
end
