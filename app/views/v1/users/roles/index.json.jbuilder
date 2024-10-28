json.roles @roles[:records] do |role|
  json.partial! role
end
json.total_count @roles[:total_count]
json.aggregators @roles[:aggs]
