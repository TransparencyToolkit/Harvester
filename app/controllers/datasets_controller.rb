class DatasetsController < ApplicationController
  before_action :set_dataset, only: [:show, :edit, :update, :destroy]

  def index
    @datasets = Dataset.all
    @crawlers = JSON.parse(Curl.get('http://0.0.0.0:9506/list_crawlers').body_str)
    @crawler_names = @crawlers.map{|c| c["classname"]}
  end

  def new
    @input = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+params["source"]).body_str)["input_params"]
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.new(dataset_params)
    @dataset.save
    @query = gen_query_url(params)
    @results = JSON.parse(Curl.get(@query).body_str)
    save_data(@results, @dataset, params)
   
    respond_to do |format|
      if @dataset.save
        format.html { redirect_to @dataset, notice: 'Dataset was successfully created.' }
        format.json { render :show, status: :created, location: @dataset }
      else
        format.html { render :new }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # Put all items for dataset in JSON
  def show
    @print_data = gen_print_data(@dataset)
  end

  private

  def make_datasetdir(dataset)
    unless File.directory?("~/Data/KG/test_dir")
      Dir.mkdir("~/Data/KG/test_dir")
    end
  end

  def save_data_files(params, print_data)
    dataset_name = params["dataset"]["search_query"]
    dirname = ENV['HOME']+"/Data/KG/"
    filename = dirname+dataset_name.gsub(" ", "_").gsub("/", "-")+".json"
    File.write(filename, print_data)
    # TODO: Later add files per search term and split by data source
  end

  # Save all data
  def save_data(results, dataset, params)
    results.each do |dataitem|
      item = LinkedinProfile.create(dataitem)
      dataset.linkedin_profiles << item
      item.dataset = dataset
    end

    print_data = gen_print_data(dataset)
    save_data_files(params, print_data)
  end

  def gen_print_data(dataset)
    result_data = dataset.linkedin_profiles.inject([]) do |all_items, item|
      all_items.push(item.as_json["linkedin_profile"])
    end
    print_data = JSON.pretty_generate(result_data)
  end
  
  def gen_query_url(params)
    url = "http://0.0.0.0:9506/crawlers?"
    url += "crawler=LinkedinCrawl"
    
    # Add all params for dataset
    params["dataset"].each do |param|
      url += "&"+param[0]+"="+Base64.encode64(param[1]).strip
    end
    return url
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_dataset
    @dataset = Dataset.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dataset_params
    params.require(:dataset).permit(:name)
  end
end
