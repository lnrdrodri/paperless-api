json.city do 
  json.partial! 'v1/users/addresses/city', city: address.city
end
json.state do
  json.partial! 'v1/users/addresses/state', state: address.city.state
end
json.country do
  json.partial! 'v1/users/addresses/country', country: address.city.state.country
end