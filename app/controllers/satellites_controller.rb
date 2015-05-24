class SatellitesController < ApplicationController
  before_action :set_active
  before_action :find_satellite, only: [:edit, :update, :destroy]

  def index
    @satellites = Satellite.all
  end

  def new
    @satellite = Satellite.new
  end

  def edit

  end

  def create
    @satellite = Satellite.create(satellite_params)
    if @satellite.errors.empty?
      flash[:notice] = 'New satellite successfully added.'
      redirect_to satellites_path
    else
      flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      render 'edit'
    end
  end

  def update
    @satellite.update_attributes(satellite_params)
    if @satellite.errors.empty?
      flash[:notice] = 'Satellite successfully updated.'
      redirect_to satellites_path
    else
      flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      render 'edit'
    end
  end

  def destroy
    @satellite.destroy
    redirect_to action: 'index'
  end

  private

  def set_active
    @active = 'satellites'
  end

  def satellite_params
    params.require(:satellite).permit(:name, :description)
  end

  def find_satellite
    @satellite = Satellite.where(id: params[:id]).first
    render text: 'Not found', status: 404 unless @satellite
  end

end
