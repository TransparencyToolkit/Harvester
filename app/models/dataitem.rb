class Dataitem
  include Neo4j::ActiveNode
  has_many :both, :dataset, type: 'data_in_set'
  has_many :both, :terms, type: 'data_collected_on_topic'
end
