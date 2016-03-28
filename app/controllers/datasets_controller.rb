class DatasetsController < ApplicationController
  include IndexData
  def index
    @datasets = Dataset.all
  end

  def sources
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
    # Setup dataset and terms
    @dataset = Dataset.new(dataset_params)
    created_terms = gen_new_terms(dataset_params[:input_query_fields])
    @dataset.save
    associate_terms_with_dataset(@dataset, created_terms)

    # Collect data
    loop_and_run(dataset_params, @dataset)

    respond_to do |format|
      if @dataset.save
        format.html { redirect_to action: "index", notice: 'Dataset was successfully created.' }
        format.json { render action: "index", status: :created, location: @dataset }
      else
        format.html { render :new }
        format.json { render json: @dataset.errors, status: :unprocessable_entity }
      end
    end
  end

  # Loop through all terms and run
  def loop_and_run(params, dataset)
    dataset.terms.each do |term|
      term_query = term[:term_query]
      query = gen_query_url(term_query, params)
      curl_url = Curl.get(query).body_str
      results = JSON.parse(curl_url)
      save_data(results, dataset, term, params, val_string(term_query))
    end
  end

  # Put all items for dataset in JSON
  def show
    set_dataset
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
    results_dir = ENV['HOME']+"/Data/KG/"+params["name"].gsub(" ", "_").gsub("/", "-")+"_"+params["source"]+"/"
    unless File.directory?(results_dir)
      Dir.mkdir(results_dir)
    end

    # Set output filename based on output and timestamp
    filename = results_dir+out_file_name+Time.now.to_s.split(" ")[0].gsub("-", "")+".json"
    File.write(filename, print_data)
  end

  # Add has_many association between two objects both ways
  def add_association(field1, item2)
    field1 << item2
  end

  # Save all data
  def save_data(results, dataset, term, params, out_file_name)
    results.each do |dataitem|
      # Create item for appropriate model
      classname = get_item_classname(params["source"])
      item_values = gen_params_hash(dataitem)
      item = eval "ClassGen::#{classname}.create(#{item_values})"
      
      # Add association with dataset and term
      add_association(dataset.dataitems, item)
      add_association(term.dataitems, item)
    end

    index_elastic(term.dataitems, params["source"])
    save_data_files(params, JSON.pretty_generate(results), out_file_name)
  end

  def associate_terms_with_dataset(dataset, term_list)
    term_list.each do |term|
      add_association(dataset.terms, term)
    end
  end

  # Creates a new term for each item in list
  def gen_new_terms(term_list)
    all_terms = Array.new

    # Make new term for each search term
    term_list.each do |k, v|
      all_terms.push(Term.create({term_query: v}))
    end

    # Return the created terms
    return all_terms
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
      par = query[param] ? Base64.encode64(query[param]).strip : ""
      url += "&"+param+"="+par
    end

    return url
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_dataset
    @dataset = Dataset.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dataset_params
    name = params.require(:dataset).permit(:name)
    return name.merge(params.permit(:source)).merge({input_query_fields: params.require(:input_query_fields)})
  end
end
