class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def origin
    @origin = ActiveShipping::Location.new(country: "US", state: "WA", city: "Seattle", zip: "98109")
  end

  def destination
    country = @betsy_shipping["country"]
    city = @betsy_shipping["city"]
    state = @betsy_shipping["state"]
    zip = @betsy_shipping["zip"]
    @destination = ActiveShipping::Location.new(country: country, state: state, city: city, zip: zip)
    # @destination = ActiveShipping::Location.new(country:"US", state: "MT", city: "Boise", zip: "59001")
  end

  def package
    @package = ActiveShipping::Package.new( @betsy_shipping["total_weight"].to_i,             # 7.5 lbs, times 16 oz/lb.
                                          [15, 10, 4.5],        # 15x10x4.5 inches
                                          :units => :imperial)  # not grams, not centimetres
  end

  def estimate_request
    @betsy_shipping = params
    origin
    destination
    package
    ups = ActiveShipping::UPS.new(:login => ENV["ACTIVESHIPPING_UPS_LOGIN"], :password => ENV["ACTIVESHIPPING_UPS_PASSWORD"], :key => ENV["ACTIVESHIPPING_UPS_KEY"])

    ups_response = ups.find_rates(@origin, @destination, @package)

    ups_rates = ups_response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    render json: ups_rates.as_json
  end
end
