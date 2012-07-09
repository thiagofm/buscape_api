require "httparty"

module Buscape
  class API 
    include HTTParty

    def initialize(options = {})
      @sandbox = options[:sandbox]
      @app_id = options[:app_id]
      # Raise exception when app_id is invalid/empty
    end

    def base_uri 
      @sandbox ? "http://sandbox.buscape.com" : "http://bws.buscape.com"
    end

    def method_missing(method, args)
      if Category.new.respond_to?(method)
        Category.new.send(method.to_sym, args, base_uri)
      end
    end

  end
end

class Category
    def category(args, uri)
      @base_uri = uri + "/categoria/"+args.to_s
      self
    end

    def method_missing(method, args)
      if Product.new.respond_to?(method)
        Product.new.send(method.to_sym, args, @base_uri)
      end
    end
end

class Product
  def product(args, uri)
    @base_uri = uri + "/produto/"+args.to_s
    self
  end

  def method_missing(method)
    @base_uri 
    p "Executar req no servidor com "+ @base_uri
    p "Retornar .name do json recebido"
  end
end

b= Buscape::API.new
b.category(15).product(19).get
