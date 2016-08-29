class Term
  include Mongoid::Document
  field :term_query, type: Hash
  field :selector_num
  field :collection_tag
  field :selector_tag
  field :overall_tag
  
  # Associations
  belongs_to :dataset
  has_many :dataitems
end
