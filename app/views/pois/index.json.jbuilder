json.array!(@pois) do |poi|
  json.extract! poi, :latitude, :longitude, :address
  json.url poi_url(poi, format: :json)
end
