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
    @server = Server.new
    @server.dns_name = server_params['dns_name']
    if server_params['ip_address'] == ''
        @server.resolv_ip
    else
      @server.ip_address = server_params['ip_address']
    end
    @server.comment = server_params['comment']
    @server.save
    if @server.errors.empty?
      flash[:notice] = 'New server successfully added.'
      redirect_to servers_path
    else
      if @server.errors.messages[:ip_address].include?('can\'t be blank')
        flash.now[:alert] = 'Can\'t resolve DNS name. Please, enter IP address manually.'
      else
        flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      end
      render 'edit'
    end
  end

  def update
    @server.dns_name = server_params['dns_name']
    if server_params['ip_address'] == ''
      @server.resolv_ip
    else
      @server.ip_address = server_params['ip_address']
    end
    @server.comment = server_params['comment']
    @server.save
    if @server.errors.empty?
      flash[:notice] = 'Information about server successfully updated.'
      redirect_to servers_path
    else
      if @server.errors.messages[:ip_address].include?('can\'t be blank')
        flash.now[:alert] = 'Can\'t resolve DNS name. Please, enter IP address manually.'
      else
        flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      end
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
