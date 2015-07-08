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

class DashboardController < ApplicationController
  def index
    @activity = CheckResult.paginate(:page => params[:page], :per_page => 30).order('id DESC')
    @active = 'all'
    render 'index'
  end

  def failed
    @activity = CheckResult.where(passed: false)
    @activity = @activity.paginate(:page => params[:page], :per_page => 30).order('id DESC')
    @active = 'failed'
    render 'index'
  end

  def passed
    @activity = CheckResult.where(passed: true)
    @activity = @activity.paginate(:page => params[:page], :per_page => 30).order('id DESC')
    @active = 'passed'
    render 'index'
  end

end
