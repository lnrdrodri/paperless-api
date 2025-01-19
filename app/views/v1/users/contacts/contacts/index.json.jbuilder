json.contacts @contacts[:records] do |contact|
  json.partial! contact
end
json.total_count @contacts[:total_count]
