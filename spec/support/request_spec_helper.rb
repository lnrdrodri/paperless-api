module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def login_user(user)
    { 'Authorization' => "Bearer #{JWT.encode({user_id: user.id}, ENV['HASH_TOKEN'])}" }
  end

  def without_login
    expect(response).to have_http_status(401)
    expect(json['errors']).to eq("User not logged")
  end


  def compare_attr(instance_attributes, instance)
    instance_attributes.each do |key, instance_attribute|
      if key.to_s.include?('_attributes')
        instance_attribute.each do |value|
          expect(!instance.send(key.to_s.split('_attributes')[0].nil?).as_json.find do |v|
                   v[value.as_json.keys[0]] == value.as_json.values[0]
                 end).to be_truthy
        end

        next
      end

      next if instance[key.to_s].instance_of?(ActiveSupport::TimeWithZone)

      if instance[key.to_s].is_a?(Numeric)
        expect(instance_attribute.to_s).to eq(instance[key.to_s].to_s)
        next
      end

      if instance[key.to_s].instance_of?(BigDecimal)
        expect(instance_attribute.to_f.round(2)).to eq(instance[key.to_s].to_f.round(2))
        next
      end

      expect(instance_attribute).to eq(instance[key.to_s])
    end
  end
end