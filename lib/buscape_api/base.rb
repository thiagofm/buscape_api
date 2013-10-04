require 'httparty'

class Base
  include HTTParty

  def initialize(options = {})
    raise "No :app_id set" unless options.include? :app_id
    options[:format] = 'json' # JSON is more lightweight than xml
    @options = options
    @services = [
      { :method => :categories, :service => :findCategoryList },
      { :method => :products, :service => :findProductList },
      { :method => :offers, :service => :findOfferList, :item => :offer },
      { :method => :top_products, :service => :topProducts },
      { :method => :user_ratings, :service => :viewUserRatings },
      { :method => :product_details, :service => :viewProductDetails },
      { :method => :seller_details, :service => :viewSellerDetails }
    ]
    @methods = @services.map { |service| service[:method] }
    @url = base_url
  end
  
  def base_url
    @options[:sandbox] ? "http://sandbox.buscape.com" : "http://bws.buscape.com"
  end

  def select_service(method)
    @services.each do |s|
      @service = s[:service] if s.values.include? method
    end
    @url << '/service/' << @service.to_s
  end

  def set_app_id
    @url << '/' << @options[:app_id]
  end
  
  def set_api
    (@url << '/' << @options[:api]) if @options[:api].present?
  end  

  def select_country
    @url << '/' << @options[:country_code]
  end
 
  def parameterize(options)
    parameters = String.new

    options.keys.each_with_index do |parameter,index|
      index == 0 ? @url << "/?#{parameter}=#{options[parameter]}" : @url << "&#{parameter}=#{options[parameter]}"
    end
  end

  def method_missing(method, *args)
    if @methods.include? method
      select_service method
      set_api
      set_app_id
      select_country if @options.include? :country_code
      self
    elsif method == :where
      parameterize args.first
      response = self.class.get(URI::encode(@url))['Result']
    else
      raise NoMethodError
    end
  end
end
