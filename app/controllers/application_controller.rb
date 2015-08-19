class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def origin
    Location.new(country: "US", state: "WA", city: "Seattle", postal_code: "98109")
  end

  def estimate_request
    package = ActiveShipping::Package.new( 7.5 * 16,             # 7.5 lbs, times 16 oz/lb.
                                          [15, 10, 4.5],        # 15x10x4.5 inches
                                          :units => :imperial)  # not grams, not centimetres

    render json: request.body.read
  end
end
