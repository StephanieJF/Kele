require 'httparty'
require './lib/roadmap.rb'

class Kele
  include HTTParty
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    response = self.class.post('https://www.bloc.io/api/v1/sessions', body: { email: email, password: password })
    @auth_token = response["auth_token"]
    raise "Invalid credentials" if response.code != 200
  end

  def get_me
    response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: {"authorization" => @auth_token})
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: {"authorization" => @auth_token})
    JSON.parse(response.body).to_a
  end

  def get_messages(page = nil)
    if page
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", body: { page: page }, headers: {"authorization" => @auth_token})
      JSON.parse(response.body)
    else
      response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: {"authorization" => @auth_token})
      JSON.parse(response.body)
    end
  end

  def create_message(sender, recipient_id, token, subject, text)
    response = self.class.post("https://www.bloc.io/api/v1/messages", body: { sender: sender, recipient_id: recipient_id, token: token, subject: subject, text: text }, headers: {"authorization" => @auth_token})
    JSON.parse(response.body)
    raise "Invalid input" if response.code != 200
  end

  def get_remaining_checkpoints(chain_id)
    response = self.class.get("https://www.bloc.io/api/v1/enrollment_chains/#{chain_id}/checkpoints_remaining_in_section", headers: {"authorization" => @auth_token})
    JSON.parse(response.body)
  end
end