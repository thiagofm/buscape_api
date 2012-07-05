# require lib 
require 'require_all'
require_all 'lib/buscape_api'

# require dependancies
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'turn'
require 'ap'
 
Turn.config do |c|
 c.format  = :outline
 c.trace   = true
 c.natural = true
end
 
VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/buscape_api'
  c.hook_into :webmock
end
