# require dependancies
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'turn'
require 'ap'
require 'require_all'

# require lib 
require_all 'lib/'

Turn.config do |c|
 c.format  = :outline
 c.trace   = true
 c.natural = true
end
 
VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/buscape_api'
  c.hook_into :webmock
end
