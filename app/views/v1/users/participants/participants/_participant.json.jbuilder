json.id participant.id
json.name participant.name
json.cnpj participant.cnpj
json.addresses participant.addresses do |address|
  json.partial! 'v1/users/addresses/address', address: address
end
json.created_at participant.created_at
json.updated_at participant.updated_at
