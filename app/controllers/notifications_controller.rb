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

class NotificationsController < ApplicationController

  before_action :set_active
  before_action :find_notification, only: [:show, :edit, :update, :destroy]
  before_action :find_notification_for_server, only: [:add_server, :add_all_servers, :remove_server]

  def index
    @notifications = Notification.all
  end

  def show
    @servers = Server.all
  end

  def new
    @notification = Notification.new
  end

  def edit
  end

  def create
    @notification = Notification.create(notification_params)
    if @notification.errors.empty?
      flash[:notice] = 'New notification successfully added.'
      redirect_to notifications_path
    else
      flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      render 'edit'
    end
  end

  def update
    @notification.update_attributes(notification_params)
    if @notification.errors.empty?
      flash[:notice] = 'Notification successfully updated.'
      redirect_to notifications_path
    else
      flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      render 'edit'
    end
  end

  def destroy
    @notification.destroy
    redirect_to action: 'index'
  end

  def add_server
    server = Server.where(id: params[:id]).first
    render_404 unless server
    @notification.servers << server
    redirect_to notification_path(@notification)
  end

  def add_all_servers
    @notification.servers << Server.all
    redirect_to notification_path(@notification)
  end

  def remove_server
    ServerNotification.where(server_id: params[:id], notification_id: params[:notification_id]).first.delete
    redirect_to "#{notification_path(@notification)}#notifications"
  end
  private

  def set_active
    @active = 'notifications'
  end

  def notification_params
    params.require(:notification).permit(:notification_type, :value)
  end

  def find_notification
    @notification = Notification.where(id: params[:id]).first
    render_404 unless @notification
  end

  def find_notification_for_server
    @notification = Notification.where(id: params[:notification_id]).first
    render_404 unless @notification
  end

end
