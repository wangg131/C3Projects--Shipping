require 'rails_helper'
require 'support/vcr_setup'
require 'rubygems'

RSpec.describe PackagesController, type: :controller do

  describe "POST rates" do
    let(:json) { JSON.parse(response.body) }

    context "valid params" do
      let(:betsy_shipping) {
        { zip: "98101", city: "Seattle", state: "WA", country: "US", box_size: "medium", total_weight: "12.0", controller: "packages", action: "estimate_request"}
        }

      before :each do
        VCR.use_cassette 'delete' do
          get :estimate_request, betsy_shipping
        end
      end

      it "is successful" do
        expect(response.response_code).to eq(200)
      end

      it "returns json" do
        expect(response.header['Content-Type']).to include 'application/json'
      end

      it "is an array of arrays" do
        expect(json).to be_an_instance_of Array
      end
    end
  end

  describe "parses the betsy shipping request" do
    let(:betsy_shipping) {
      {
        origin: { zip: "98101", city: "Seattle", state: "WA", country: "US"},
        destination: { city: "Burlington", state: "WA", zip: "98233", country: "USA" },
        package: {:weight => 12, :sizing => "[8,8,8]"}
        }
      }

    before :each do
      VCR.use_cassette 'delete' do
        get :estimate_request, betsy_shipping
      end
    end

    it "creates an origin object" do
      expect(controller.send(:origin)).to be_an_instance_of ActiveShipping::Location
    end

    it "creates a destination object" do
      VCR.use_cassette 'package_create_response' do
        get :estimate_request, origin: { :city =>"Seattle", :state =>"WA", :zip=>98109, :country =>"US"}, destination: {:city =>"Burlington",:state =>"WA",:zip =>98233,:country => "US"},package: {:weight => 12,:sizing => "[8,8,8]"}
        end
        expect(controller.send(:destination)).to be_an_instance_of ActiveShipping::Location
    end

    it "creates a package object" do
      VCR.use_cassette 'package' do
        expect(controller.send(:package)).to be_an_instance_of ActiveShipping::Package
      end
    end
  end

  describe "get carrier quote" do

    it "creates UPS instances" do
      VCR.use_cassette 'ups' do
        expect(controller.send(:estimate_request)).to include(ActiveShipping::UPS)
      end
    end

    it "creates USPS instances" do
      VCR.use_cassette'usps' do
        expect(controller.send(:estimate_request)).to include(ActiveShipping::USPS)
      end
    end

  describe "packages#save" do
    it "saves a record of the shipping information" do
      Package.create(weight: 29.5, sizing: "[12, 5, 4]", order_id: 1, service_type: "Bike delivery", price: 674)
      expect(Package.count).to eq(1)
      end
    end
  end
end
