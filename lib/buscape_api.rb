require "httparty"

# Loading and requiring all api files
Dir[File.dirname(__FILE__) + '/buscape_api/*.rb'].each { require file }
