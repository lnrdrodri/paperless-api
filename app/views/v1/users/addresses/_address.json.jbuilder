json.id address.id
json.street address.street
json.number address.number
json.complement address.complement
json.neighborhood address.neighborhood
json.zip_code address.zip_code
json.city_id address.city_id
json.reference_type address.reference_type
json.reference_id address.reference_id
json.created_at address.created_at
json.updated_at address.updated_at
json.is_deleted address.is_deleted
json.location do
  json.partial! 'v1/users/addresses/location', address: address
end