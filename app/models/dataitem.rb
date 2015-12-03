class Dataitem
  include Neo4j::ActiveNode
  has_one :out, :dataset, type: :dataset
end
