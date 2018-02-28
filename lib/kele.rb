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

  def get_mentor_availability(mentor_id)
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: {"authorization" => @auth_token})
    JSON.parse(response.body)
  end

  def get_messages(page = nil)
    if page #returns specific page of messages entered
      response = self.class.get(
        "/message_threads/",
        headers: { "authorization" => @auth_token },
        body: { "page": page })
    else #returns all messages if no page entered
      response = self.class.get(
        "/message_threads/",
        headers: { "authorization" => @auth_token })
    end
    raise 'Unable to get messages' if response.code != 200
    @messages = JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, stripped_text)
    response = self.class.post("https://www.bloc.io/api/v1/messages",
      body: {
        "sender": sender,
        "recipient_id": recipient_id,
        "token": token,
        "subject": subject,
        "stripped-text": stripped_text
      },
      headers: {"authorization" => @auth_token})
    if response.success?
      puts "message sent!"
    end
  end
end
