require 'httparty'
require 'pry'
require 'json'

class Kele
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'
  include JSON

  def initialize(email, password)
    response = self.class.post('/sessions', body: { "email": email, "password": password } )
    @auth_token = response["auth_token"]
    if @auth_token == nil
      puts 'Invalid Credentials'
    else
      puts 'Welcome'
    end
  end

  def get_me
    response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: {"authorization" => @auth_token})
    JSON.parse(response.body)
  end
end
