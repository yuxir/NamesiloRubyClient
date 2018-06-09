require 'faraday'
require 'json'
require 'addressable'

module NamesiloClient
  class API
    
    # Class constructor
    def initialize(apikey)
      @apikey = apikey
      @host   = 'https://www.namesilo.com/api/'
    end

    # Establish connection
    def get_connection()
      conn = Faraday.new(:url => @host) do |c|
        c.use Faraday::Request::UrlEncoded 
        c.use Faraday::Adapter::NetHttp     
      end
    end

    # Default parameters for Namesilio REST APIs
    def get_default_parameters()
      {"version":"1","type":"xml","key":@apikey}
    end

    def get_request(endpoint)
      get_connection().get endpoint
    end

    # Construct URL parameters, combing with default parameters
    def get_url_parameters(params)
      uri = Addressable::URI.new
      uri.query_values = params.merge(get_default_parameters())
      uri.query
    end

    # Return namesilo account information
    def get_account()
      get_request('contactList?'+get_url_parameters({})).body
    end

    # List all domains
    def list_domains()
      get_request('listDomains?'+get_url_parameters({})).body
    end

    # Get domain info
    def get_domain_info(domain)
      get_request('getDomainInfo?'+get_url_parameters({'domain':domain})).body
    end

    # List DNS records
    def list_dns_records(domain)
      get_request('dnsListRecords?'+get_url_parameters({'domain':domain})).body
    end

    # portfolioList
    def get_portfolio_list()
      get_request('portfolioList?'+get_url_parameters({})).body
    end

    # listRegisteredNameServers
    def list_name_servers(domain)
      get_request('listRegisteredNameServers?'+get_url_parameters({'domain':domain})).body
    end

    # listEmailForwards
    def list_email_forwards(domain)
      get_request('listEmailForwards?'+get_url_parameters({'domain':domain})).body
    end

    # registrantVerificationStatus
    def get_registrant_verification_status()
      get_request('registrantVerificationStatus?'+get_url_parameters({})).body
    end


  end
end
