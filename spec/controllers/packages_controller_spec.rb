require 'rails_helper'
require 'support/vcr_setup'

RSpec.describe PackagesController, type: :controller do

  describe "get estimate_request" do
    let(:package1) { Package.create weight: 12.0}

    it 'is successful' do
      VCR.use_cassette 'package_create_response' do
        get :estimate_request, origin: {:city =>"Seattle", :state =>"WA", :zip =>"98109", :country =>"US"}, destination: {:city =>"Burlington", :state =>"WA", :zip =>"98233", :country => "US"}, package: {:weight => 12.0}
        expect(response.response_code).to eq 200
      end
    end
  end

  describe "parses the betsy shipping request" do

    it "creates an origin object" do
      expect(controller.send(:origin)).to be_an_instance_of ActiveShipping::Location
    end

    it "creates a destination object" do
      expect(controller.send(:destination)).to be_an_instance_of ActiveShipping::Location
    end

    it "creates a package object" do
      expect(controller.send(:package)).to be_an_instance_of ActiveShipping::Package
    end
  end

  describe "get carrier quote" do

    it "creates UPS instances" do
      VCR.use_cassette 'ups' do
        expect(controller.send(:estimate_request)).to include(ActiveShipping::UPS)
      end
    end

    it "creates USPS instances" do
      VCR.use_cassette 'usps' do
        expect(controller.send(:estimate_request)).to include(ActiveShipping::USPS)
      end
    end

    it "returns all carrier options" do
      VCR.use_cassette 'controller/carriers' do
        carrier_rates = (controller.send(:estimate_request))
        expect(carrier_rates).to include("")
      end
    end

  end
end
