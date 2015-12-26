class DatasetsController < ApplicationController
  before_action :set_dataset, only: [:show, :edit, :update, :destroy]

  def index
    @datasets = Dataset.all
    @crawlers = JSON.parse(Curl.get('http://0.0.0.0:9506/list_crawlers').body_str)
    @crawler_names = @crawlers.map{|c| c["classname"]}
  end

  def new
    @crawler = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+params["source"]).body_str)
    @input = @crawler["input_params"]
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.new(dataset_params)
    @dataset.save
    loop_and_run(params, @dataset)

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

  # Loop through all terms and run
  def loop_and_run(params, dataset)
    params[:input_query_fields].each do |key, value|
      query = gen_query_url(value, params)
      results = JSON.parse(Curl.get(query).body_str)
      save_data(results, dataset, params, val_string(value))
    end
  end

  # Put all items for dataset in JSON
  def show
    @print_data = gen_print_data(@dataset)
  end

  private

  # Generate value string name for files
  def val_string(value)
    value_str = ""
    value.each do |k, v|
      value_str += v.gsub(" ", "_").gsub("/", "-").gsub(":", "")+"_"
    end
    return value_str
  end

  # Save folders of data files
  def save_data_files(params, print_data, out_file_name)
    # Create results directory with name based on dataset
    results_dir = ENV['HOME']+"/Data/KG/"+params["dataset"]["name"].gsub(" ", "_").gsub("/", "-")+"_"+params["source"]+"/"
    unless File.directory?(results_dir)
      Dir.mkdir(results_dir)
    end

    # Set output filename based on output and timestamp
    filename = results_dir+out_file_name+Time.now.to_s.split(" ")[0].gsub("-", "")+".json"
    File.write(filename, print_data)
  end

  # Save all data
  def save_data(results, dataset, params, out_file_name)
    results.each do |dataitem|
      # Create item for appropriate model
      classname = get_item_classname(params["source"])
      item_values = gen_params_hash(dataitem)
      item = eval "ClassGen::#{classname}.create(#{item_values})"

      # Add association with dataset
      dataset.dataitems << item
      item.dataset = dataset
    end

    save_data_files(params, JSON.pretty_generate(results), out_file_name)
  end

  # Generate parameters hash
  def gen_params_hash(dataitem)
    item_hash = Hash.new
    output_fields = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+params["source"]).body_str)["output_fields"]
    output_fields.each do |field|
      item_hash[field] = dataitem[field]
    end

    return item_hash
  end

  # Get classname of form SourcenameItem
  def get_item_classname(source)
    name = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+params["source"]).body_str)["name"]
    gen_class_name(name)
  end

  # Generate JSON with all data to print on show view
  def gen_print_data(dataset)
    result_data = dataset.dataitems.inject([]) do |all_items, item|
      all_items.push(item.as_json.first[1])
    end
    print_data = JSON.pretty_generate(result_data)
  end

  # Generate URL with params and crawler info
  def gen_query_url(query, params)
    @input_params = JSON.parse(Curl.get("http://0.0.0.0:9506/get_crawler_info?crawler="+params["source"]).body_str)["input_params"]

    # Gen url base
    url = "http://0.0.0.0:9506/crawlers?"
    url += "crawler="+params[:source]

    # Add all params for dataset
    @input_params.each do |param, type|
      url += "&"+param+"="+Base64.encode64(query[param]).strip
    end

    return url
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_dataset
    @dataset = Dataset.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dataset_params
    params.require(:dataset).permit(:name, :input_query_fields)
  end
end
