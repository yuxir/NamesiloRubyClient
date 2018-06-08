require 'spec_helper'
require 'namesilo_client'
require 'dotenv'
require 'nokogiri'

describe NamesiloClient do

  Dotenv.load
  client = NamesiloClient::API.new(ENV['APIKEY'])  

  it "has get_account" do
    response = client.get_account()
    expect(response.length).to be > 0
    xml_doc  = Nokogiri::XML(response)
    expect(xml_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('contactList')
    expect(xml_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
  end

end
