json.array!(@datasets) do |dataset|
  json.extract! dataset, :id, :name
  json.url dataset_url(dataset, format: :json)
end
