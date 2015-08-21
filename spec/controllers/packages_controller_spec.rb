require 'rails_helper'
require 'support/vcr_setup'
require 'rubygems'

RSpec.describe PackagesController, type: :controller do

  describe "POST rates" do
    let(:json) { JSON.parse(response.body) }

    context "valid params" do
      let(:params) {
        { zip: "98101", city: "Seattle", state: "WA", country: "US", box_size: "medium", total_weight: "12.0", controller: "packages", action: "estimate_request"}
        }

      before :each do
        VCR.use_cassette 'delete' do
          get :estimate_request, params
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

  describe "changes box size to dimensions" do
    it "changes the box size received form bEtsy to dimensions that can be comsumed by the shipping API gem" do
      @controller = PackagesController.new
      @box_size = "small"
      @controller.instance_eval{ set_box_size }
      expect(@controller.instance_eval{ set_box_size }).to eq([8, 8, 8])
    end
  end

  describe "parses the betsy shipping request" do
    let(:params) {
      { zip: "98101", city: "Seattle", state: "WA", country: "US", box_size: "medium", total_weight: "12.0", controller: "packages", action: "estimate_request"}
      }

    before :each do
      VCR.use_cassette 'delete' do
        get :estimate_request, params
      end
    end

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

  describe "rescue methods" do
    before do
      allow(ActiveShipping::USPS).to receive(:new).and_raise(ActiveShipping::ResponseError)
    end
    it "" do
      get :estimate_request
      expect(response.response_code).to eq(400)
    end
  end


  describe "packages#save" do
    let(:params) do
      {
      order:
        {
        estimate:
          {
          service: "USPS Media Mail Parcel 272",
          service_info:
            {
            estimate:
              {
              name:"Brenna Leker",
              email:"brennarama@gmail.com",
              street:"924 Shorewood Dr",
              city:"Bremerton",
              state:"WA",
              zip:"98312",
              country:"US",
              box_size:"medium",
              total_weight:"12.0"}}}},
                id:"13"}
    end
    it "saves a record of the shipping information" do
      post :save, params
      expect(Package.count).to eq(1)
    end
  end
end
