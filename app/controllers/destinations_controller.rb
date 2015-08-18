class DestinationsController < ApplicationController

  def destination
    Shipment.new(country: "US", state: state, city: city, postal_code: postal_code)
  end
end
