class ShipmentsController < ApplicationController

  def new
    @shipment = Shipment.new
  end

  def create
    @shipment = Shipment.new(shipment_params)
    if @shipment.save?
      flash[:success] = "The shipment has been created."
    else
      flash[:error] = "Please make sure that you have selected from the options above before selecting 'Estimate'"
    end
  end

private

  def shipment_paramts
    params.require(:shipment).permit(:name, :country, :city, :state, :postal_code, :weight)
  end

end
