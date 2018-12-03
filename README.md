# Integration Project 
A simple integration with Braintree's API. Utilizing JavaScript Hosted Fields and Ruby on Rails. 

## Getting Started

### Ruby version
ruby 2.3.7p456

### Database
SQLite version 3.19.3 2017-06-27 16:48:08

### System dependencies
Run bundle install 
Run bundle exec figaro install  
Run rake db:migrate 

### Configuration
cd into app
Copy and paste:

BRAINTREE_MERCHANT_ID: ''
BRAINTREE_PUBLIC_KEY: ''
BRAINTREE_PRIVATE_KEY: ''

Enter Sandbox credentials into the config/application.yml file 
-merchant id, public key, and private key

These keys can be found in your sandbox account.
If you don't have an account visit here https://www.braintreepayments.com/sandbox

### Run the code
Run rails server 
visit http://localhost:3000/




