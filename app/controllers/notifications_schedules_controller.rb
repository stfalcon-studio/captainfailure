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

class NotificationsSchedulesController < ApplicationController
  before_action :find_notification
  before_action :find_notifications_schedule, only: [:edit, :update, :destroy]

  def index

  end

  def new
    @notifications_schedule = NotificationsSchedule.new
  end

  def edit

  end

  def create
    @notifications_schedule = NotificationsSchedule.create(notifications_schedule_params)
    if @notifications_schedule.errors.empty?
      flash[:notice] = 'New schedule successfully added.'
      @notification.notifications_schedules << @notifications_schedule
      redirect_to notification_notifications_schedules_path(@notification)
    else
      @notifications_schedule.errors.messages.each { |msg| flash.now[:alert] = msg[1][0] }
      render 'edit'
    end
  end

  def update
    @notifications_schedule.update_attributes(notifications_schedule_params)
    if @notifications_schedule.errors.empty?
      flash[:notice] = 'Schedule successfully updated.'
      redirect_to notification_notifications_schedules_path(@notification)
    else
      @notifications_schedule.errors.messages.each { |msg| flash.now[:alert] = msg[1][0] }
      render 'edit'
    end
  end

  def destroy
    @notifications_schedule.destroy
    redirect_to notification_notifications_schedules_path(@notification)
  end

  private

  def notifications_schedule_params
    params.require(:notifications_schedule).permit(:m, :h, :dom, :mon, :dow)
  end
  def find_notification
    @notification = Notification.where(id: params[:notification_id]).first
    render text: 'Not found', status: 404 unless @notification
  end

  def find_notifications_schedule
    @notifications_schedule = NotificationsSchedule.where(id: params[:id]).first
    render text: 'Not found', status: 404 unless @notifications_schedule
  end
end
