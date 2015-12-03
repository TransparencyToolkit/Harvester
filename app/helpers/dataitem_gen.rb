module DataitemGen
  def create_all_models
    @source_model_list = Array.new
    @crawlers = JSON.parse(Curl.get('http://0.0.0.0:9506/list_crawlers').body_str)
    @crawlers.each do |crawler|
      @source_model_list.push(create_model(crawler))
    end

    return @source_model_list
  end

  # Call classgen to make a new model for the data source
  def create_model(crawler)
    name = gen_class_name(crawler["name"])
    fields = crawler["output_fields"]
    return ClassGen.gen_class(name, fields)
  end

  # Generate a name for the model
  def gen_class_name(name)
    return name.split(" ").map{ |c| c.capitalize}.join+"Item"
  end
end
