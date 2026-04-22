json.cities @cities[:records] do |city|
  json.partial! 'v1/users/addresses/city', city: city
end
json.total_count @cities[:total_count]
json.aggregators @cities[:aggs]
