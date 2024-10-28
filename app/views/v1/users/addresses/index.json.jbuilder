json.addresses @addresses[:records] do |address|
  json.partial! address
end
json.total_count @addresses[:total_count]
json.aggregators @addresses[:aggs]