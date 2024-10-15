json.users @users[:records] do |user|
  json.partial! user
end
json.total_count @users[:total_count]
