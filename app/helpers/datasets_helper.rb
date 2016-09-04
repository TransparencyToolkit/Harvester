module DatasetsHelper
  # Get count of all results
  def get_overall_count
    #TODO: Will need to modify this to work with domains!
    return Dataitem.all.length
  end

  # Get number of results for single dataset
  def get_count_per_dataset(dataset)
    return dataset.dataitems.length
  end

  # Generate JSON with all data to print on show view
  def gen_print_data(dataset)
    result_data = dataset.dataitems.inject([]) do |all_items, item|
      all_items.push(Dataitem.find(item).as_json)
    end
    result_data
  end
end
