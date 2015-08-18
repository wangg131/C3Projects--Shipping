require 'active_shipping'
class Shipment < ActiveRecord::Base
  validates :name, presence: true
  validates :country, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :weight, presence: true

  def origin
    Location.new(country: "US", state: "WA", city: "Seattle", postal_code: "98109")
  end

  def destination
    Shipment.new(country: "US", state: state, city: city, postal_code: postal_code)
  end

end
