require 'spec_helper'
require 'namesilo_client'
require 'dotenv'

describe NamesiloClient do

  Dotenv.load
  client = NamesiloClient::API.new(ENV['APIKEY'])  

  it "has get_account" do
    response = client.get_account()
    puts response
    expect(response.length).to be > 0
  end

end
