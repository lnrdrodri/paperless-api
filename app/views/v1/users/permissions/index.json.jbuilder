json.permissions @permissions[:records] do |permission|
  json.partial! permission
end
json.total_count @permissions[:total_count]
json.aggregators @permissions[:aggs]
