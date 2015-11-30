class Dataset 
  include Neo4j::ActiveNode
  property :search_query, type: String
  has_many :in, :linkedin_profiles, origin: :dataset


end
