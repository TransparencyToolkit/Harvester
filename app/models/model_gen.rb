module ModelGen
  def gen_spec(properties)
    properties.each do |p|
      field p.to_sym
    end
  end
end
