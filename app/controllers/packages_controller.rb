class PackagesController < ApplicationController

  def origin
    @origin = ActiveShipping::Location.new(country: "US",
                                          state: "WA",
                                          city: "Seattle",
                                          zip: "98109")
  end

  def destination
    country = @betsy_shipping["country"]
    city = @betsy_shipping["city"]
    state = @betsy_shipping["state"]
    zip = @betsy_shipping["zip"]

    @destination = ActiveShipping::Location.new(country: country,
                                                state: state,
                                                city: city,
                                                zip: zip)
  end

  def package
    @box_size = @betsy_shipping["box_size"]
    if @box_size == "large"
      @box_size = [16, 12, 8]
    elsif @box_size == "medium"
      @box_size = [12, 12, 12]
    else
      @box_size = [8, 8, 8]
    end

    @package = ActiveShipping::Package.new(@betsy_shipping["total_weight"].to_i,
                                            @box_size, :units => :imperial)
  end

  def estimate_request # api endpoint
    @betsy_shipping = params
    origin
    destination
    package

    ups = ActiveShipping::UPS.new(:login => ENV["ACTIVESHIPPING_UPS_LOGIN"],
                                  :password => ENV["ACTIVESHIPPING_UPS_PASSWORD"],
                                  :key => ENV["ACTIVESHIPPING_UPS_KEY"])
    ups_response = ups.find_rates(@origin, @destination, @package)
    ups_rates = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    usps = ActiveShipping::USPS.new(:login => ENV["ACTIVESHIPPING_USPS_LOGIN"])
    usps_response = usps.find_rates(@origin, @destination, @package)
    usps_rates = usps_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    carrier_rates = []
    carrier_rates.push(ups_rates, usps_rates)
    render json: carrier_rates.as_json

  end

  def save
    weight = params["order"]["total_weight"]
    sizing = 
    order_id = params["id"]

    Package.create(weight: weight, sizing: sizing, order_id: order_id)



  end


end
