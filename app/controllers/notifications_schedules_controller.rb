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

class NotificationsSchedulesController < SchedulesController
  before_action :find_notification
  before_action :set_parent_controller
  before_action :find_schedule, only: [:edit, :update, :destroy]

  def index
    @schedule_name = @schedulable_model.value
  end

  def schedule_polymorphic_path(object)
    notification_notifications_schedules_path(object)
  end

  private

  def find_notification
    @schedulable_model = Notification.where(id: params[:notification_id]).first
    render_404 unless @schedulable_model
  end

  def find_schedule
    @schedule = Schedule.where(id: params[:id]).first
    render_404 unless @schedule
  end

  def set_parent_controller
    @parent_controller = 'notifications'
  end

end
