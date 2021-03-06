class VehiclesController < ApplicationController

  def index
  end

  def show
    @vehicle = Vehicle.find(params[:id])
  end
  
  def inspect
    @vehicle = Vehicle.find(params[:price])
  end

  def new
  end

  def create
    unless vehicle_params[:make].empty? || vehicle_params[:model].empty?
      vehicle = Vehicle.new(vehicle_params)
      vehicle.save
      redirect_to user_path(current_user.id)
    end
  end
  
  def edit
    @vehicle = Vehicle.find(params[:id])
  end

  def update
    @vehicle = Vehicle.find(params[:vehicle][:vehicle_id])
    @vehicle.update(vehicle_params)
    @vehicle.save
    redirect_to vehicle_path(@vehicle.id)
  end
  
  def oilchange
    vehicle = Vehicle.find(params[:vehicle][:id])
    vehicle.update(mileage: params[:vehicle][:mileage])
    log = AutoLog.new(entry: ("Oil change @ " + params[:vehicle][:mileage]).to_s, vehicle_id: params[:vehicle][:id])
    log.save
    vehicle.save
    redirect_to vehicle_path(vehicle.id)
  end
  
  def mpg
    @vehicle = Vehicle.find(params[:id])
    @vehicle.update(mpg: @vehicle.mpg_calc(params[:miles], params[:gallons]))
    @vehicle.save
    redirect_to vehicle_path(@vehicle.id)
  end

  
  def destroy
    Vehicle.delete(params[:delete])
    redirect_to user_path(current_user.id)
  end
  
  def sell
    @vehicle = Vehicle.find(params[:id])
    unless params[:price].empty?
      @vehicle.update(sale_price: params[:price])
    end
    if @vehicle.for_sale === false
      @vehicle.update(for_sale: true)
    else
      @vehicle.update(for_sale: false)
    end
    @vehicle.save
    redirect_to vehicle_path(@vehicle.id)
  end
  
  def sales
    @vehicles = Vehicle.all
  end

  private
  

  def vehicle_params
    params.require(:vehicle).permit(:make, :model, :year, :color, :mpg, :sale_price, :mileage, :user_id)
  end
end
