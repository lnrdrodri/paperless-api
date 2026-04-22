json.id unit.id
json.name unit.name
json.cnpj unit.cnpj
json.success_percentage unit.success_percentage
json.royalts unit.royalts
json.status unit.status
json.addresses unit.addresses.active do |address|
  json.partial! 'v1/users/addresses/address', address: address
end
json.contacts unit.contacts.active do |contact|
  json.partial! 'v1/users/contacts/contacts/contact', contact: contact
end
json.created_at unit.created_at
json.updated_at unit.updated_at
