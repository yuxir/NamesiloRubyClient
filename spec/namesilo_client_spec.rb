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

  it "has list_domains" do
    response = client.list_domains()
    expect(response.length).to be > 0
    xml_doc  = Nokogiri::XML(response)
    expect(xml_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('listDomains')
    expect(xml_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
  end

  it "has get_domain_info" do
    domains_doc  = Nokogiri::XML(client.list_domains())
    domains_doc.xpath('/namesilo/reply/domains/domain').each do |domain|
      domain_doc = Nokogiri::XML(client.get_domain_info(domain.text()))
      expect(domain_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('getDomainInfo')
      expect(domain_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
    end
  end

  # Test list_dns_records
  it "has list_dns_records" do
    domains_doc  = Nokogiri::XML(client.list_domains())
    domains_doc.xpath('/namesilo/reply/domains/domain').each do |domain|
      dns_doc = Nokogiri::XML(client.list_dns_records(domain.text()))
      expect(dns_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('dnsListRecords')
      expect(dns_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
    end
  end

  # get_portfolio_list
  it "has get_portfolio_list" do
    xml_doc  = Nokogiri::XML(client.get_portfolio_list())
    expect(xml_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('portfolioList')
    expect(xml_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
  end
  
  # Test list_name_servers
  it "has list_name_servers" do
    domains_doc  = Nokogiri::XML(client.list_domains())
    domains_doc.xpath('/namesilo/reply/domains/domain').each do |domain|
      ns_doc = Nokogiri::XML(client.list_name_servers(domain.text()))
      expect(ns_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('listRegisteredNameServers')
      expect(ns_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
    end
  end

  # Test list_email_forwards
  it "has list_email_forwards" do
    domains_doc  = Nokogiri::XML(client.list_domains())
    domains_doc.xpath('/namesilo/reply/domains/domain').each do |domain|
      ef_doc = Nokogiri::XML(client.list_email_forwards(domain.text()))
      expect(ef_doc.xpath('/namesilo/request/operation/text()').to_s).to eq('listEmailForwards')
      expect(ef_doc.xpath('/namesilo/reply/detail/text()').to_s).to eq('success')
    end
  end


end
