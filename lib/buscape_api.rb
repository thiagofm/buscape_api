require "require_all"

# Loading and requiring all api files
require_all 'lib/buscape_api'

class Buscape
  def initialize(options = {})
    @options = options 
  end

  def method_missing(method, *args)
    Base.new(@options).send(method, args.first)
  end
end