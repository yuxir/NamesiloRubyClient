# Namesilo Ruby client

Please follow me at: https://steemit.com/@yuxi

## What is the project about?

This project is aiming to provide a Ruby client for Namesilo REST APIs. This gem can be used in Ruby/Rails application to retrieve information form Namesilo and send requests to Namesilo server, e.g. listing all domains, email forwards, url forwards, register a new domain, renew a domain etc.   

> Namesilo makes an application programming interface (API) available to all users as a convenience to customers who have additional automation requirements. The API allows access to accounts via our users' own software as opposed to needing to log in through our web interface.

![](https://cdn.steemitimages.com/DQmcS2mbFsh2YEhGeqRuV4ipaEZK5HMQF3zE874DgWLiSeu/image.png)

## Technology Stack

Ruby V2.4

Gem V2.6.11

## Roadmap

The current implementation mainly focus on retrieving information from Namesio via its REST APIs e.g. contact list, account balance, orders, domains information, dns records, name servers, domain transfer status, Namesilo portfolio list etc. As an API wrapper, all methods provided in the Namesilo REST API will be supported in this Ruby client in the following versions.

## Test

A set of rspec test has been written here: 

https://github.com/yuxir/NamesiloRubyClient/blob/master/spec/namesilo_client_spec.rb

## How to contribute?

Just fork this project, create your feature branch, commit your changes and send a pull request!

https://github.com/yuxir/NamesiloRubyClient
    
## Installation

This gem has been registered in rubygems.org:
https://rubygems.org/gems/namesilo_client

Assuming you already have Ruby development configured, then run:

```bash
gem install namesilo_client
```

Basic usage:

```ruby
require 'namesilo-client'

client = NamesiloClient::API.new(‘YOUR_API_KEY’)
response = client.get_contact_list()
```

