class Crawler
  include Mongoid::Document

  field :name
  field :icon
  field :description
  field :classname
  field :input_params, type: Hash
  field :output_fields, type: Array
end
