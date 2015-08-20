require 'rails_helper'
require 'support/vcr_setup'

RSpec.describe ApplicationController, type: :controller do

  describe "application#package" do
    let(:package1) { Package.create weight: 12.0}

    it 'creates a new package' do
      package1
      expect(assigns(:package1).weight.to eq(12.0))
    end
  end

  describe "application#estimate_request" do

    before :each do
      VCR.use_cassette 'package_create_response' do
        get :estimate_request, package: { weight: 20.0 }
      end
    end

    it "creates a package record" do
        expect(Package.count).to eq(1)
        expect(Package.first.weight).to eq(20.0)
    end
  end
end
