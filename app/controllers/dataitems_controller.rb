class DataitemsController < ApplicationController
  include SaveData
  include ProgressBox
  def new
  end

  def create
    @dataitem = Dataitem.new(dataitem_params) # FIX PARAMS
  end

  # Save the result info
  def save_results
    # Extract result info from params
    selector_id = params["selector_id"].split("_", 2).last
    source = params["selector_id"].split("_", 2).first
    status_message = params["status_message"]
    results = JSON.parse(params["results"])

    # Get corresponding selector
    matching_selector = Term.where(overall_tag: selector_id).entries.select{|s| s.dataset.source == source}.first
    collection = matching_selector.dataset
    
    # Update progress box
    append_message(collection, status_message)

    # Save data (in background)
    #    Resque.enqueue(SaveData, results, collection, matching_selector, collection.source, val_string(matching_selector.term_query))
    SaveData.perform(results, collection, matching_selector, collection.source, val_string(matching_selector.term_query))
  end

  # Add a new status message
  def save_status_message
    # Extract result info from params
    selector_id = params["selector_id"].split("_", 2).last
    source = params["selector_id"].split("_", 2).first
    status_message = params["status_message"]

    # Get corresponding selector
    matching_selector = Term.where(overall_tag: selector_id).entries.select{|s| s.dataset.source == source}.first
    collection = matching_selector.dataset

    # Update progress box
    append_message(collection, status_message)
  end

  private

  # Permit all
  def dataitem_params
    params.permit!
  end
end
