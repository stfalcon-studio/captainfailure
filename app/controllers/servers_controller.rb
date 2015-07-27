# Copyright 2015 Evgeniy Gurinovich
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class ServersController < ApplicationController

  before_action :set_active
  before_action :find_server,               only: [:show, :edit, :update, :destroy]
  before_action :find_server_for_satellite, only: [:remove_satellite, :add_satellite, :add_all_satellites, :add_notification, :add_all_notifications, :remove_notification, :notification_fail_count_up, :notification_fail_count_down]
  before_action :find_server_notification,  only: [:notification_fail_count_up, :notification_fail_count_down]

  def index
    @servers = Server.all
  end

  def show
    @satellites    = Satellite.all
    @notifications = Notification.all
    @check_types   = Check.check_types.keys
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
    @server.comment  = server_params['comment']
    @server.alert_on = server_params['alert_on']
    @server.save
    if @server.errors.empty?
      flash[:notice] = 'New server successfully added.'
      redirect_to server_path(@server)
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
    @server.comment  = server_params['comment']
    @server.alert_on = server_params['alert_on']
    @server.save
    if @server.errors.empty?
      flash[:notice] = 'Information about server successfully updated.'
      redirect_to server_path(@server)
    else
      if @server.errors.messages[:ip_address].include?('can\'t be blank')
        flash.now[:alert] = 'Can\'t resolve DNS name. Please, enter IP address manually.'
      else
        flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      end
      render 'new'
    end
  end

  def add_satellite
    satellite = Satellite.where(id: params[:id]).first
    render text: 'Not found', status: 404 unless satellite
    @server.satellites << satellite
    redirect_to "#{server_path(@server)}#satellites"
  end

  def add_all_satellites
    @server.satellites = Satellite.all
    redirect_to "#{server_path(@server)}#satellites"
  end

  def remove_satellite
    @server.satellites.delete(params[:id])
    redirect_to "#{server_path(@server)}#satellites"
  end

  def add_notification
    notification = Notification.where(id: params[:id]).first
    render text: 'Not found', status: 404 unless notification
    @server.notifications << notification
    redirect_to "#{server_path(@server)}#notifications"
  end

  def add_all_notifications
    @server.notifications = Notification.all
    redirect_to "#{server_path(@server)}#notifications"
  end

  def remove_notification
    ServerNotification.where(server_id: params[:server_id], notification_id: params[:id]).first.delete
    redirect_to "#{server_path(@server)}#notifications"
  end

  def notification_fail_count_up
    @server_notification.fail_to_notify_count += 1
    @server_notification.save
    redirect_to "#{server_path(@server)}#notifications"
  end

  def notification_fail_count_down
    @server_notification.fail_to_notify_count -= 1
    @server_notification.save
    redirect_to "#{server_path(@server)}#notifications"
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
    params.require(:server).permit(:dns_name, :ip_address, :comment, :alert_on)
  end

  def find_server
    @server = Server.where(id: params[:id]).first
    render text: 'Not found', status: 404 unless @server
  end

  def find_server_for_satellite
    @server = Server.where(id: params[:server_id]).first
    render text: 'Not found', status: 404 unless @server
  end

  def find_server_notification
    @server_notification = ServerNotification.where(server_id: params[:server_id], notification_id: params[:id]).first
    render text: 'Not found', status: 404 unless @server_notification
  end

end
