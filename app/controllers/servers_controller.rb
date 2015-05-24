class ServersController < ApplicationController

  before_action :set_active
  before_action :find_server, only: [:edit, :update, :destroy]

  def index
    @servers = Server.all
  end

  def new
    @server = Server.new
  end

  def edit

  end

  def create
    @server = Server.create(server_params)
    if @server.errors.empty?
      flash[:notice] = 'New server successfully added.'
      redirect_to servers_path
    else
      flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      render 'edit'
    end
  end

  def update
    @server.update_attributes(server_params)
    if @server.errors.empty?
      flash[:notice] = 'Information about server successfully updated.'
      redirect_to servers_path
    else
      flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      render 'new'
    end
  end

  def destroy
    @server.destroy
    redirect_to servers_path
  end

  private

  def set_active
    @active = 'servers'
  end

  def server_params
    params.require(:server).permit(:dns_name, :ip_address, :comment)
  end

  def find_server
    @server = Server.where(id: params[:id]).first
    render text: 'Not found', status: 404 unless @server
  end

end
