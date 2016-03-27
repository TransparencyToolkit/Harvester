class Dataset 
  include Neo4j::ActiveNode
  property :name, type: String
  property :input_query_fields
  serialize :input_query_fields, Hash
  property :source
  has_many :both, :dataitems, type: 'data_in_set'
  has_many :both, :terms, type: 'search_term_in_dataset'
end
