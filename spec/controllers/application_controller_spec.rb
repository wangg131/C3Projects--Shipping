require 'rails_helper'
require 'support/vcr_setup'

RSpec.describe ApplicationController, type: :controller do

  before(:each) do
    @origin = ActiveShipping::Location.new(country: "US", state: "WA", city: "Seattle", zip: "98109")
    @destination = create :destination
    @package = create :package
  end


  describe "get estimate_request" do
    it 'is successful' do
      VCR.use_cassette 'package_create_response' do
        get :estimate_request, { destination: @destination}, origin: @origin, package: @package
      #package1
        expect(response.response_code).to eq 200
      #expect(assigns(:package1).weight.to eq(12.0))
      end
    end
  end

  describe "application#package" do
    let(:package1) { Package.create weight: 12.0}

    it 'creates a new package' do
      package1
      expect(assigns(:package1).weight.to eq(12.0))
    end
  end

  describe "application#estimate_request" do

    before :each do
      @origin = ActiveShipping::Location.new(country: "US", state: "WA", city: "Seattle", zip: "98109")
      VCR.use_cassette 'package_create_response' do
        get :estimate_request, { destination: attributes_for(:destination)}, @origin
      end
    end

    it "creates a package record" do
        expect(Package.count).to eq(1)
        expect(Package.first.weight).to eq(20.0)
    end
  end
end
