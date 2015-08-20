require 'rails_helper'

RSpec.describe Package, type: :model do
  describe "validations" do
    let(:package1) { Package.new weight: 12}


    it "requires a weight" do
      p = Package.new
      expect(p).to_not be_valid
      expect(p.errors.keys).to include :weight
    end

  end
end
