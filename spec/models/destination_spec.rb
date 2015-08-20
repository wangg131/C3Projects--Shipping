require 'rails_helper'

RSpec.describe Destination, type: :model do
  describe "validations" do
    let(:destination1) { Destination.new(name: "Name" , country: 'US', city: 'Tinseltown', state: 'PA', zip: 98201 ) }

    it "requires all the attributes" do
      d = Destination.new
      expect(d).to_not be_valid
      expect(d.errors.keys).to include :street, :country, :city, :state, :zip
    end
  end
end
