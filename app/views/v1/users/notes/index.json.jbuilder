json.notes @notes[:records] do |note|
  json.partial! note
end
json.total_count @notes[:total_count]
json.aggregators @notes[:aggs]