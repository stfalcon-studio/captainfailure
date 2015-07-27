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

class ChecksController < ApplicationController

  before_action :find_server
  before_action :find_check, only: [:edit, :update, :destroy]

  def index
  end

  def new
    @check = Check.new
  end

  def edit
  end

  def create
    @check = Check.create(check_params)
    if @check.errors.empty?
      flash[:notice] = 'New check successfully added.'
      @server.checks << @check
      redirect_to "#{server_path(@server)}#checks"
    else
      @check.errors.messages.each { |msg| flash.now[:alert] = msg[1][0] }
      render 'edit'
    end
  end

  def update
    @check.update_attributes(check_params)
    if @check.errors.empty?
      flash[:notice] = 'Check successfully updated.'
      redirect_to "#{server_path(@server)}#checks"
    else
      @check.errors.messages.each { |msg| flash.now[:alert] = msg[1][0] }
      render 'edit'
    end
  end

  def destroy
    @check.destroy
    redirect_to "#{server_path(@server)}#checks"
  end

  def disable_check
    @check = Check.where(id: params[:check_id]).first
    render text: 'Not found', status: 404 unless @check
    @check.enabled = 'no'
    @check.save
    redirect_to "#{server_path(@server)}#checks"
  end

  def enable_check
    @check = Check.where(id: params[:check_id]).first
    render text: 'Not found', status: 404 unless @check
    @check.enabled = 'yes'
    @check.save
    redirect_to "#{server_path(@server)}#checks"
  end

  private

  def check_params
    params.require(:check).permit(:check_type, :check_via, :tcp_port, :http_code, :http_keyword,
                                  :http_vhost, :icmp_count, :http_uri, :http_protocol, :enabled,
                                  :check_interval, :timeout)
  end

  def find_server
    @server = Server.where(id: params[:server_id]).first
    render text: 'Not found', status: 404 unless @server
  end

  def find_check
    @check = Check.where(id: params[:id]).first
    render text: 'Not found', status: 404 unless @check
  end

end
