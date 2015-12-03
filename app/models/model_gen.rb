module ModelGen
  def gen_spec(properties)
    properties.each do |p|
      property p.to_sym
    end
  end
end
