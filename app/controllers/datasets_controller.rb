class DatasetsController < ApplicationController
  include TagGen
  include CollectData
  include UpdateColselec
  include SaveColselec
  include DatasetsHelper
  include ScheduleRecrawl
  def index
    @datasets = Dataset.all
  end

  def destroy
    @dataset = Dataset.find(params[:id])

    # Delete associated terms and items
    d = DeleteData.new
    d.delete_collection(@dataset.dataitems, @dataset.terms)

    # Destroy and show notification
    respond_to do |format|
      if @dataset.destroy
        format.html { redirect_to action: "index", notice: 'Collection was successfully deleted' }
      end
    end
  end

  # Recrawl mutiple terms in dataset
  def recrawl_collection
    @dataset = Dataset.find(params[:collection])
  end

  # Recrawl list of items
  def recrawl_items
    # Get list of selectors and dataset from params
    recrawl_list = params["selectors_to_recrawl"].map{|s| Term.find(s)}
    @dataset = Dataset.find(params["collection"])

    # Save info needed to rescrape datast
    check_if_schedule_changed(@dataset, recrawl_list, params["recrawl_frequency"], params["recrawl_interval"])

    # Recrawl and redirect
    loop_and_run(@dataset.source, @dataset, recrawl_list) if params["recrawl_interval"] != "never"
    redirect_to @dataset
  end

  def sources
    @datasets = Dataset.all
    @crawlers = JSON.parse(Curl.get('http://0.0.0.0:9506/list_crawlers').body_str)
    @crawler_names = @crawlers.map{|c| c["classname"]}
  end

  def edit
    @dataset = Dataset.find(params[:id])
    @crawler = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+@dataset.source).body_str)
    @input = @crawler["input_params"]
  end

  def update
    @dataset = Dataset.find(params[:id])

    # Update recrawl schedule
    check_if_schedule_changed(@dataset, @dataset.terms, params["recrawl_frequency"], params["recrawl_interval"])

    # Update the selectors
    find_updated_selectors(dataset_params)
    update_selectors(params["recrawl_frequency"], params["recrawl_interval"])
    @dataset.update_attributes(dataset_params)
 
    # Collect data and save selectors
    if params.include?("commit")
      loop_and_run(dataset_params["source"], @dataset, @all_modified_selectors)
    end
    
    respond_to do |format|
      if @dataset.update_attributes(dataset_params)
        format.html { redirect_to @dataset, notice: 'Dataset was successfully updated.' }
      else
        format.html { render :new }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # New function for things on the upload form
  def new_upload
    new
  end

  def new
    @crawler = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+params["source"]).body_str)
    @input = @crawler["input_params"]
    @dataset = Dataset.new
  end

  def create
    # Save the dataset
    save_dataset(dataset_params)

    # Save the recrawl info
    save_rescrape_info(@dataset, @dataset.terms, params["recrawl_frequency"], params["recrawl_interval"])
         
    # Just show selectors saved
    if params.include?("save")
      save_success
      
    # Collect data and save selectors
    elsif params.include?("commit")
      collect_data(dataset_params)
    end
  end

  # Put all items for dataset in JSON
  def show
    set_dataset
    @print_data = gen_print_data(@dataset)
  end

  private
  
  # Also collect data
  def collect_data(dataset_params)
    loop_and_run(dataset_params["source"], @dataset, @dataset.terms)

    respond_to do |format|
      if @dataset.save
        format.html { redirect_to @dataset, notice: 'Dataset was successfully collected.' }
        format.json { render @dataset, status: :created, location: @dataset }
      else
        format.html { render :new }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # Show it successfully saved
  def save_success
    respond_to do |format|
      if @dataset.save
        format.html { redirect_to @dataset, notice: 'Dataset was successfully saved.' }
        format.json { render @dataset, status: :created, location: @dataset }
      else
        format.html { render :new }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_dataset
    @dataset = Dataset.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dataset_params
    params[:input_query_fields] = {empty: "empty"} if params[:input_query_fields].empty?
    name = params.require(:dataset).permit(:name)
    return name.merge(params.permit(:source)).merge({input_query_fields: params.require(:input_query_fields)})
  end
end
