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

  end
end
