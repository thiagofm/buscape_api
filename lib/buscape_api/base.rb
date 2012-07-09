require 'awesome_print'
require 'observer'
require 'httparty'

module RequestBuilder
  class Base
    include Observable

    def change(message)
      changed
      notify_observers(message)
    end
  end

  class ServiceBuilder < RequestBuilder::Base
    def categories
      change([:uri_chunk, "/service/findCategoryList"])
    end

    def products
      change([:uri_chunk, "/service/findProductList"])
    end

    def offers
      change([:uri_chunk, "/service/findOfferList"])
    end

    def top_products
      change([:uri_chunk, "/service/topProducts"])
    end
    
    def user_ratings 
      change([:uri_chunk, "/service/viewUserRatings"])
    end

    def product_details
      change([:uri_chunk, "/service/viewProductDetails"])
    end
    
    def seller_details
      change([:uri_chunk, "/service/viewSellerDetails"])
    end
  end

  class AppIdBuilder < RequestBuilder::Base
    def build
      change([:app_id])
    end
  end

  class CountryCodeBuilder < RequestBuilder::Base
    def build
      change([:country_code])
    end
  end

  class ParamsBuilder < RequestBuilder::Base
    def parameterize(options)
      parameters = String.new
      options = options.first

      options.keys.each_with_index do |parameter,index|
        index == 0 ? parameters << "/?#{parameter}=#{options[parameter]}" : parameters << "&#{parameter}=#{options[parameter]}"
      end
      
      change([:uri_chunk, parameters])
    end

    def categories(options)
      parameterize(options)
    end

    def products(options)
      parameterize(options)
    end

    def offers(options)
      parameterize(options)
    end

    def top_products
      parameterize(options)
    end

    def user_ratings
      parameterize(options)
    end

    def product_details
      parameterize(options)
    end

    def seller_details 
      parameterize(options)
    end
  end
end

module Buscape
  class Base
    include HTTParty
    include RequestBuilder

    def initialize(options = {})
      @sandbox = options[:sandbox]
      @app_id = options[:app_id]
      @country_code = options[:country_code]
      select_base_uri
      # Raise exception when app_id is invalid/empty
    end

    def select_base_uri
      @uri = @sandbox ? "http://sandbox.buscape.com" : "http://bws.buscape.com"
    end

    def dispatch(object, method, *args)
      object.add_observer(self, :listener)
      if args.empty?
        (object.respond_to? method) ? object.send(method) : (raise NoMethodError, "Method \"#{method}\" does not exist." )
      else
        (object.respond_to? method) ? object.send(method, args.first) : (raise NoMethodError, "Method \"#{method}\" does not exist.")
      end
    end

    def method_missing(method, *args)
      if args.empty?
        dispatch(ServiceBuilder.new, method)
        dispatch(AppIdBuilder.new, :build)
        dispatch(CountryCodeBuilder.new, :build)
      else
        dispatch(ParamsBuilder.new, :categories, args)
      end

      self
    end

    def listener(action)
      case action.first
        when :uri_chunk then @uri << action[1]
        when :app_id then @uri << '/' << @app_id
        when :country_code then (@uri << '/' << @country_code) unless @country_code.nil?
      end
    end
  end
end

buscape= Buscape::Base.new(:app_id => '67514c517532314f3148343d', :sandbox => true, :country_code => 'BR')
buscape2= Buscape::Base.new(:app_id => '67514c517532314f3148343d', :sandbox => true, :country_code => 'BR')
buscape3= Buscape::Base.new(:app_id => '67514c517532314f3148343d', :sandbox => true, :country_code => 'BR')
buscape4= Buscape::Base.new(:app_id => '67514c517532314f3148343d', :sandbox => true, :country_code => 'BR')
buscape5= Buscape::Base.new(:app_id => '67514c517532314f3148343d', :sandbox => true, :country_code => 'BR')
buscape6= Buscape::Base.new(:app_id => '67514c517532314f3148343d', :sandbox => true, :country_code => 'BR')
buscape7= Buscape::Base.new(:app_id => '67514c517532314f3148343d', :sandbox => true, :country_code => 'BR')

#b.category(15).product(19).name
ap buscape.categories.where(:categoryId => '1', :keyword => 'celular')
ap buscape2.products.where(:categoryId => '1', :keyword => 'celular')
ap buscape3.offers.where(:categoryId => '1', :keyword => 'celular')
ap buscape4.top_products.where(:categoryId => '1', :keyword => 'celular')
ap buscape5.user_ratings.where(:productId => '1')
ap buscape6.product_details.where(:productId => '1')
ap buscape7.seller_details.where(:sellerId => '1')
