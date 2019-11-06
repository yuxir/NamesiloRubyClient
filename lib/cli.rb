module NamesiloClient
  class Cli
    def initialize
      @client = NamesiloClient::API.new(NAMESILO_API_KEY)
    end

    def domains
      @domains ||= list_domains["domains"]["domain"]
    end

    def add_aa(full_domain, ip)
      splitted = full_domain.split('.')
      domain = splitted.pop
      domain = splitted.pop + '.' + domain
      unless domains.include?(domain)
        fail "Not found domain: #{domain}"
      end
      host = splitted.join('.')

      existing_records_list = list_dns_records(domain)["resource_record"]

      existing_record = existing_records_list.find do |record|
        record["host"] == full_domain
      end

      if existing_record && existing_record["value"] == ip
        puts "Such record already exists: \n#{existing_record}"
        return
      end

      if existing_record
        puts "Updating existing record. It was: \n#{existing_record}"
        update_dns_record({rrid: existing_record['record_id'], domain: domain, rrhost: host, rrvalue: ip, rrtype: "A"})
      else
        puts "Adding new record"
        # Add a DNS record
        # Parameters:
        #   domain: The domain being updated
        #   rrtype: DNS record type, e.g. "A", "AAAA", "CNAME", "MX" and "TXT"
        #   rrhost: hostname for the new record
        #   rrvalue: The value for the resource record
        #   rrdistance: Only used for MX (default is 10 if not provided)
        #   rrttl: The TTL for the new record (default is 7207 if not provided)
        add_dns_record({domain: domain, rrhost: host, rrvalue: ip, rrtype: "A"})
      end
    end

    def method_missing(method, *args, &block)
      body = @client.send(method, *args, &block)
      parser = Nori.new
      parser.parse(body)["namesilo"]["reply"]
    end
  end
end
