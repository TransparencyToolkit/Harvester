class Dataitem
  include Mongoid::Document
  include GlobalID::Identification
  belongs_to :dataset
  belongs_to :term
  field :collection_time
  field :matching_id
end
