class Dataset
  include Mongoid::Document
  include Mongoid::Paperclip
  
  # Fields
  field :name
  field :input_query_fields, type: Hash
  field :source
  field :collection_tag
  has_mongoid_attached_file :selector_file
  
  # Associations
  has_many :terms
  has_many :dataitems
end
