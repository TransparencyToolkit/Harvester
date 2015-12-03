class Dataset 
  include Neo4j::ActiveNode
  property :name, type: String
  property :input_query_fields
  has_many :in, :dataitems, origin: :dataset

  # And add input field- for JSON of queries
  # Group and save in input
  # Update query manager
  
  # Add dynamic # of inputs on form
  # Add function to run queries one after the other and parse correctly and save
end
