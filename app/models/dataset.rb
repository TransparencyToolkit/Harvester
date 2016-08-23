class Dataset
  include Mongoid::Document

  # Fields
  field :name
  field :input_query_fields, type: Hash
  field :source
  
  # Associations
  has_many :terms
  has_many :dataitems
end
