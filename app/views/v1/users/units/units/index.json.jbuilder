json.units @units[:records] do |unit|
  json.partial! unit
end
json.total_count @units[:total_count]
