require (File.expand_path('./../../../spec_helper', __FILE__))

describe Buscape::API do
 
  describe "default attributes" do
    it "must include httparty method" do
      Buscape::API.must_include HTTParty
    end

    it "must have the base url set to the Buscape API endpoint" do
      assert Buscape::API.new.base_uri == "http://bws.buscape.com"
    end

    it "must have the base url set to the Buscape sandbox endpoint" do
      assert_equal Buscape::API.new(:sandbox => true).base_uri, "http://sandbox.buscape.com"
    end
  end 
end
