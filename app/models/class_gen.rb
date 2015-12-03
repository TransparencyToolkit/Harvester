class ClassGen
  def self.gen_class(class_name, properties)
    new_class = Class.new(Dataitem) do
      # Set name for class
      @class_name = class_name
      def self.model_name
        ActiveModel::Name.new(self, nil, @class_name)
      end

      # Import needed methods
      extend ModelGen

      # Gen properties
      gen_spec(properties)
    end

    # Set constant and return class
    const_set(class_name, new_class)
    return new_class
  end
end
