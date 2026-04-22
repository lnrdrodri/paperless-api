json.id participant.id
json.name participant.name
json.cnpj participant.cnpj
json.company_name participant.company_name
json.document participant.document
json.taxation_regime participant.taxation_regime
json.invoicing participant.invoicing
json.status participant.status
json.unit_id participant.unit_id
json.addresses participant.addresses.active do |address|
  json.partial! 'v1/users/addresses/address', address: address
end
json.created_at participant.created_at
json.updated_at participant.updated_at
