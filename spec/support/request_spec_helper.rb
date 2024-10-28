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
end