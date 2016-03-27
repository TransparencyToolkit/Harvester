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
end
