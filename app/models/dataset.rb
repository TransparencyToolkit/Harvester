class Dataset 
  include Neo4j::ActiveNode
  property :name, type: String
  property :input_query_fields
  serialize :input_query_fields, Hash
  property :source
  has_many :in, :dataitems, origin: :dataset
end
