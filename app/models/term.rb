class Term
  include Mongoid::Document
  field :term_query, type: Hash
  
  # Associations
  belongs_to :dataset
  has_many :dataitems
end
