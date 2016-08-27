class Term
  include Mongoid::Document
  field :term_query, type: Hash
  field :selector_num
  
  # Associations
  belongs_to :dataset
  has_many :dataitems
end
