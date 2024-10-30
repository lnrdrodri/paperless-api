Rswag::Api.configure do |c|
  # c.swagger_root = Rails.root.to_s + '/swagger'
  c.swagger_root = Rails.root.join('swagger').to_s
end
