require 'faraday'
require 'json'
require 'addressable'

module NamesiloClient
  class API

    def initialize(apikey)
      @apikey = apikey
      @host = 'https://www.namesilo.com/api/'
    end

    def get_connection()

      conn = Faraday.new(:url => @host) do |c|
        c.use Faraday::Request::UrlEncoded 
        c.use Faraday::Adapter::NetHttp     
      end
    end

    def get_default_parameters()
      {"version":"1","type":"xml","key":@apikey}
    end

    def get_request(endpoint)
      get_connection().get endpoint
    end

    def get_url_parameters(params)
      uri = Addressable::URI.new
      uri.query_values = params.merge(get_default_parameters())
      uri.query
    end

    def get_account()
      get_request('contactList?'+get_url_parameters({})).body
    end

  end
end
