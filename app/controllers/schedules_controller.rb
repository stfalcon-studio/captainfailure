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

class SchedulesController < ApplicationController

  def index

  end

  def new
    @schedule = Schedule.new
  end

  def edit

  end

  def create
    @schedule = Schedule.create(schedule_params)
    if @schedule.errors.empty?
      flash[:notice] = 'New schedule successfully added.'
      @schedulable_model.schedules << @schedule
      #redirect_to notification_notifications_schedules_path(@notification)
      redirect_to schedule_polymorphic_path(@schedulable_model)
    else
      @schedulable_model.errors.messages.each { |msg| flash.now[:alert] = msg[1][0] }
      render 'edit'
    end
  end

  def update
    @schedule.update_attributes(schedule_params)
    if @schedulable_model.errors.empty?
      flash[:notice] = 'Schedule successfully updated.'
      redirect_to schedule_polymorphic_path(@schedulable_model)
    else
      @schedulable_model.errors.messages.each { |msg| flash.now[:alert] = msg[1][0] }
      render 'edit'
    end
  end

  def destroy
    @schedule.destroy
    redirect_to schedule_polymorphic_path(@schedulable_model)
  end

  private

  def schedule_params
    params.require(:schedule).permit(:m, :h, :dom, :mon, :dow)
  end

end
