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

    # Return namesilo contact information
    # By default, it returns all contact informaton
    # Optional parameter: contact_id
    # e.g. get_contact_list(params={contact_id:'11111111'})
    def get_contact_list(params={})
      get_request('contactList?'+get_url_parameters(params)).body
    end

    # add a contact information
    # params is a JSON string
    # required fields:
    #   fn: First Name
    #   ln: Last Name
    #   ad: Mailing Address
    #   cy: Mailing City
    #   st: Mailing State/Province/Territory
    #   If country is US or CA, you must use the correct abbreviation
    #   zp: Mailing Zip/Postal Code
    #   ct: Mailing Country
    #   Country must use the correct abbreviation
    #   em: Email Address
    #   ph: Phone Number
    # Optional Fields
    #   nn: Nickname (24)
    #   cp: Company (64)
    #   ad2: Mailing Address 2 (128)
    #   fx: Fax (32)
    #   US Fields:
    #     usnc: .US Nexus Category (3) (must use correct abbreviation)
    #     usap: .US Application Purpose (2) (must use correct abbreviation)
    #   CA Optional Fields
    #     calf: CIRA Legal Form (correct abbreviations)
    #     caln: CIRA Language (correct abbreviations)
    #     caag: CIRA Agreement Version (correct abbreviations)
    #     cawd: CIRA WHOIS Display
    def add_contact(params)
      get_request('contactAdd?'+get_url_parameters(params)).body
    end

    # contactUpdate
    # Parameters: see add_contact
    def update_contact(params)
      get_request('contactUpdate?'+get_url_parameters(params)).body
    end

    # contactDelete
    def delete_contact(contact_id)
      params={'contact_id':contact_id}
      get_request('contactDelete?'+get_url_parameters(params)).body
    end

    # List all domains
    # Returns XML
    # xpath: /namesilo/reply/domains/domain
    def list_domains()
      get_request('listDomains?'+get_url_parameters({})).body
    end

    # Get domain info
    # Parameter: domain name
    # returns XML containing all domain info
    # xpath: /namesilo/reply
    def get_domain_info(domain)
      get_request('getDomainInfo?'+get_url_parameters({'domain':domain})).body
    end

    # List DNS records
    # Parameter: domain name
    # returns XML containing all DNS records
    # xpath: /namesilo/reply/resource_record
    def list_dns_records(domain)
      get_request('dnsListRecords?'+get_url_parameters({'domain':domain})).body
    end

    # Add a DNS record
    # Parameters:
    #   domain: The domain being updated
    #   rrtype: DNS record type, e.g. "A", "AAAA", "CNAME", "MX" and "TXT"
    #   rrhost: hostname for the new record 
    #   rrvalue: The value for the resource record
    #   rrdistance: Only used for MX (default is 10 if not provided)
    #   rrttl: The TTL for the new record (default is 7207 if not provided)
    def add_dns_record(params)
      get_request('dnsAddRecord?'+get_url_parameters(params)).body
    end

    # Update DNS record
    # Parameters:
    #   domain
    #   rrid: The unique ID of the resource record. 
    #   rrhost: The hostname
    #   rrvalue: The value for the resource record
    #   rrdistance: Only used for MX
    #   rrttl: The TTL for this record (default is 7207 if not provided)
    def update_dns_record(params)
      get_request('dnsUpdateRecord?'+get_url_parameters(params)).body
    end

    # Delete DNS record
    # Parameters:
    #  domain
    #  rrid: The unique ID of the resource record
    def delete_dns_record(params)
      get_request('dnsDeleteRecord?'+get_url_parameters(params)).body
    end

    # checkTransferStatus
    # Parameter: domain name
    # returns XML containing domain transfer status
    # xpath: /namesilo/reply
    def check_transfer_status(domain)
      get_request('checkTransferStatus?'+get_url_parameters({'domain':domain})).body
    end

    # checkRegisterAvailability
    # Parameter: register domain names in JSON, seperated by comma
    #        e.g. {'domains':'namesilo.com,namesilo.net,namesilo.org'}
    # returns XML with available, unavailable, and invalid domains
    # xpath: /namesilo/reply
    def check_register_availability(domains)
      get_request('checkRegisterAvailability?'+get_url_parameters({'domains':domains})).body
    end

    # retrieveAuthCode
    # Have the EPP transfer code for the domain emailed to the administrative contact.
    def retrieve_auth_code(domain)
      get_request('retrieveAuthCode?'+get_url_parameters({'domain':domain})).body
    end

    # Get a list of all active portfolios within your account.
    # returns XML containing all portfolios
    # xpath: /namesilo/reply/portfolios
    def get_portfolio_list()
      get_request('portfolioList?'+get_url_parameters({})).body
    end

    # listRegisteredNameServers
    # returns XML containing all name servers
    # xpath: /namesilo/reply/hosts
    def list_name_servers(domain)
      get_request('listRegisteredNameServers?'+get_url_parameters({'domain':domain})).body
    end

    # listEmailForwards
    # returns all email forwards
    # xpath: /namesilo/reply/addresses
    def list_email_forwards(domain)
      get_request('listEmailForwards?'+get_url_parameters({'domain':domain})).body
    end

    # registrantVerificationStatus
    # Shows the verification status for any Registrant email addresses
    # xpath: /namesilo/reply/email
    def get_registrant_verification_status()
      get_request('registrantVerificationStatus?'+get_url_parameters({})).body
    end

    # getAccountBalance
    # returns current account funds balance.
    # xpath: /namesilo/reply
    def get_account_balance()
      get_request('getAccountBalance?'+get_url_parameters({})).body
    end

    # getPrices
    # returns price list
    # xpath: /namesilo/reply
    def get_prices()
      get_request('getPrices?'+get_url_parameters({})).body
    end

    # listOrders
    # Returns Complete Account Order History
    # xpath: /namesilo/reply/order
    def list_orders()
      get_request('listOrders?'+get_url_parameters({})).body
    end

    # orderDetails
    # returns details for provided order number
    # xpath: /namesilo/reply
    def order_details(order_number)
      get_request('orderDetails?'+get_url_parameters({'order_number':order_number})).body
    end

    # renewDomain
    # Parameters (format should be in JSON, e.g. {'domain':'yourdomain.com','years':'1'}):
    #   domain(required): The domain to renew
    #   years(required): The number of years to renew the domain
    #
    #   payment_id(optional): the id of verified payment method, if not specified, your account balance will be used
    #   coupon(optional): the coupon code used in this transaction
    def renew_domain(params)
      get_request('renewDomain?'+get_url_parameters(params)).body
    end

    # registerDomain
    # Parameters
    #   domain(required): The domain to renew
    #   years(required): The number of years to renew the domain    
    #
    #   payment_id(optional)
    #   coupon(optional)
    #   private(optional): if the free WHOIS privacy service will be used or not 
    #   auto_renew(optional)
    #   portfolio(optional): the name of the portfolio to link the registered domain with
    #   ns1-13(optional): up to 13 name servers to use for the domain registration
    #   contact info(optional): see https://www.namesilo.com/api_reference.php#registerDomain
    def register_domain(params)
      get_request('registerDomain?'+get_url_parameters(params)).body
    end

    # transferDomain
    # Parameters 
    #   domain(required)
    #
    #   payment_id(optional)
    #   auth(optional): transfer authorization code
    #   private(optional): if you want the domain to utilize our free WHOIS privacy service
    #   auto_renew(optional) 
    #   portfolio(optional) 
    #   coupon(optional)
    #   Passing Contact Information(optional): see https://www.namesilo.com/api_reference.php#transferDomain
    #   Passing Contact ID(optional): see https://www.namesilo.com/api_reference.php#transferDomain
    def transfer_domain(params)
      get_request('transferDomain?'+get_url_parameters(params)).body
    end
    
    # transferUpdateChangeEPPCode
    # Parameters
    #   domain
    #   auth: The EPP code to use
    def transfer_update_change_epp_code(domain,epp_code)
      params={'domain':domain,'auth':epp_code}
      get_request('transferUpdateChangeEPPCode?'+get_url_parameters(params)).body
    end

    # transferUpdateResendAdminEmail
    # Parameters
    #   domain
    def transfer_update_resend_admin_email(domain)
      params={'domain':domain}
      get_request('transferUpdateResendAdminEmail?'+get_url_parameters(params)).body
    end

    # transferUpdateResubmitToRegistry
    # Parameters
    #   domain
    def transfer_update_resubmit_to_registry(domain)
      params={'domain':domain}
      get_request('transferUpdateResubmitToRegistry?'+get_url_parameters(params)).body
    end

    # checkTransferAvailability
    # Parameters
    #   domains: A comma-delimited list of domains
    def check_transfer_availability(domains)
      params={'domains':domains}
      get_request('checkTransferAvailability?'+get_url_parameters(params)).body
    end

    # contactDomainAssociate
    # Parameters
    #   domains (required)
    #
    #   registrant(optional): registrant's contact id
    #   administrative(optional): admin's contact id
    #   billing(optional): billing contact id
    #   technical(optional): technical role contact id
    def contact_domain_associate(params)
      get_request('contactDomainAssociate?'+get_url_parameters(params)).body
    end

    # changeNameServers
    # Parameters
    #  domain
    #  ns1-ns13: must provide between 2 and 13 name servers
    def change_name_servers(params)
      get_request('changeNameServers?'+get_url_parameters(params)).body
    end

    # dnsSecListRecords
    # Parameters
    #  domain
    def list_dns_sec_records(domain)
      params={'domain':domain}
      get_request('dnsSecListRecords?'+get_url_parameters(params)).body
    end

    # dnsSecAddRecord
    # Parameters
    #  domain
    #  digest: The digest
    #  keyTag: The key tag
    #  digestType: The digest type ( accepted values: https://www.namesilo.com/api_reference.php#dnsSecAddRecord )
    #  alg: see: https://www.namesilo.com/api_reference.php#dnsSecAddRecord
    def add_dns_sec_record(params)
      get_request('dnsSecAddRecord?'+get_url_parameters(params)).body
    end    

    # dnsSecDeleteRecord
    # Parameters: as same as dnsSecAddRecord
    def del_dns_sec_record(params)
      get_request('dnsSecDeleteRecord?'+get_url_parameters(params)).body
    end

    # portfolioAdd
    # Parameters:
    #  portfolio: The encoded name of the portfolio to add 
    def add_portfolio(portfolio)
      params={'portfolio':portfolio}
      get_request('portfolioAdd?'+get_url_parameters(params)).body      
    end    

    # portfolioDelete
    # Parameters:
    #  portfolio: The encoded name of the portfolio to add
    def delete_portfolio(portfolio)
      params={'portfolio':portfolio}
      get_request('portfolioDelete?'+get_url_parameters(params)).body
    end

    # portfolioDomainAssociate
    # Parameters:
    #  domains
    #  portfolio
    def associate_domain_portfolio(portfolio,domains)
      params={'portfolio':portfolio,'domains':domains}
      get_request('portfolioDomainAssociate?'+get_url_parameters(params)).body
    end

    # addRegisteredNameServer: add a registered name server
    # Parameters:
    #  new_host: the host name
    #  ip1(required): IP Address for new name server
    #  ip2-ip13(optional)
    def add_registered_name_server(params)
      get_request('addRegisteredNameServer?'+get_url_parameters(params)).body
    end     

    # modifyRegisteredNameServer
    # Parameters:
    #  current_host: current host name
    #  new_host: the new host name
    #  ip1
    #  ip2-ip13
    def modify_registered_name_server(params)
      get_request('modifyRegisteredNameServer?'+get_url_parameters(params)).body
    end

    # deleteRegisteredNameServer
    # Parameters:
    #  current_host: current host name
    def delete_registered_name_server(hostname)
      params={'hostname':hostname}
      get_request('deleteRegisteredNameServer?'+get_url_parameters(params)).body
    end

    # addPrivacy: Add WHOIS Privacy to a domain
    # Parameters:
    #  domain
    def add_privacy(domain)
      params={'domain':domain}
      get_request('addPrivacy?'+get_url_parameters(params)).body
    end

    # removePrivacy
    # Parameters:
    #  domain
    def remove_privacy(domain)
      params={'domain':domain}
      get_request('removePrivacy?'+get_url_parameters(params)).body
    end

    # addAutoRenewal: Set a domain to be auto-renewed.
    def add_auto_renewal(domain)
      params={'domain':domain}
      get_request('addAutoRenewal?'+get_url_parameters(params)).body
    end

    # removeAutoRenewal: set a domain to not be auto-renewed
    def remove_auto_renewal(domain)
      params={'domain':domain}
      get_request('removeAutoRenewal?'+get_url_parameters(params)).body
    end

    # domainForward
    # Required parameters:
    #  domain
    #  protocol: http or https
    #  address: the web site address to forward to
    #  method: "301", "302" or "cloaked"
    #  
    # Optional parameters:
    #  meta_title: The META title for cloaked forward
    #  meta_description
    #  meta_keywords: The META keywords for cloaked forward 
    def forward_domain(params)
      get_request('domainForward?'+get_url_parameters(params)).body
    end

    # domainForwardSubDomain
    # Parameters: as same as forward_domain, plus:
    #   sub_domain
    def forward_sub_domain(params)
      get_request('domainForwardSubDomain?'+get_url_parameters(params)).body
    end

    # domainForwardSubDomainDelete: delete a subdomain forward
    # Parameters
    #  domain
    #  subdomain
    def delete_forward_sub_domain(domain, subdomain)
      params={'domain':domain, 'subdomain':subdomain}
      get_request('domainForwardSubDomainDelete?'+get_url_parameters(params)).body
    end

    

  end
end
