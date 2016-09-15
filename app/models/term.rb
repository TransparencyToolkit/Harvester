class Term
  include Mongoid::Document
  include GlobalID::Identification
  field :term_query, type: Hash
  field :selector_num
  field :collection_tag
  field :selector_tag
  field :overall_tag
  field :latest_collection_time
  field :recrawl_frequency
  field :recrawl_interval
  field :next_recrawl_time
  
  # Associations
  belongs_to :dataset
  has_many :dataitems
end
