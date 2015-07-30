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
  before_action :find_all_servers, :select_server

  def index
    @activity = CheckResult.all
    unless @selected_server == 'all'
      server_id = Server.where('dns_name = ?', @selected_server)
      @activity = @activity.where(server_id: server_id)
    end
    @activity = @activity.paginate(:page => params[:page], :per_page => 30).order('id DESC')
    @active = 'all'
    render 'index'
  end

  def failed
    @activity = CheckResult.where(passed: false)
    unless @selected_server == 'all'
      server_id = Server.where('dns_name = ?', @selected_server)
      @activity = @activity.where(server_id: server_id)
    end
    @activity = @activity.paginate(:page => params[:page], :per_page => 30).order('id DESC')
    @active = 'failed'
    render 'index'
  end

  def passed
    @activity = CheckResult.where(passed: true)
    unless @selected_server == 'all'
      server_id = Server.where('dns_name = ?', @selected_server)
      @activity = @activity.where(server_id: server_id)
    end
    @activity = @activity.paginate(:page => params[:page], :per_page => 30).order('id DESC')
    @active = 'passed'
    render 'index'
  end

  private
  def find_all_servers
    @servers = Server.all
  end

  def select_server
    if params[:server]
      @selected_server = params[:server]
      render text: 'Not found', status: 404 unless server_names.include?(@selected_server) or @selected_server == 'all'
    else
      @selected_server = 'all'
    end
  end

  def server_names
    server_names = []
    @servers.each { |server| server_names << server.dns_name }
    server_names
  end

end
