json.participants @participants[:records] do |participant|
  json.partial! participant
end
json.total_count @participants[:total_count]
json.aggregators @participants[:aggs]
