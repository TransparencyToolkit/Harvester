class DataitemsController < ApplicationController
  include SaveData
  def new
  end

  def create
    @dataitem = Dataitem.new(dataitem_params) # FIX PARAMS
  end

  # Save the result info
  def save_results
    # Extract result info from params
    selector_id = params["selector_id"]
    status_message = params["status_message"]
    results = JSON.parse(params["results"])

    # Get corresponding selector
    matching_selector = Term.find_by({overall_tag: selector_id})
    collection = matching_selector.dataset

    # Save data (in background)
    Resque.enqueue(SaveData, results, collection, matching_selector, collection.source, val_string(matching_selector.term_query))
  end

  private

  # Permit all
  def dataitem_params
    params.permit!
  end
end
