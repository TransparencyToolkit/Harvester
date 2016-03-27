class Term
  include Neo4j::ActiveNode
  property :term_query
  serialize :term_query, Hash

  # Associations
  has_many :both, :dataitems, type: 'data_collected_on_topic'
  has_many :both, :datasets, type: 'search_term_in_dataset'
end
