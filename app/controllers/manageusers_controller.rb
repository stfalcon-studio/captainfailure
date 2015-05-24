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

class ManageusersController < ApplicationController

  before_action :check_permission
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :set_active

  #get /users/manage
  def index
    @users = User.all
    render 'manageusers/index'
  end

  def show
  end

  def new
    @user = User.new
  end

  #post /users/manage
  def create
    @user = User.create(params.require(:user).permit(:name, :email, :password, :password_confirmation, :is_admin))
    if @user.errors.empty?
      redirect_to '/users/manage'
    else
      @save_errors = ''
      @user.errors.messages.each_key { |key| @save_errors << "#{key} #{@user.errors.messages[key][0]}" }
      render 'new'
    end
  end

  #get /users/manage/:id
  def edit
  end

  #put /users/manage/:id
  def update
    if params[:user][:password] == '' and params[:user][:password_confirmation] == ''
      update_params = :name, :email, :is_admin
    else
      update_params = :name, :email, :password, :password_confirmation, :is_admin
    end
    @user.update_attributes(params.require(:user).permit(update_params))
    if @user.errors.empty?
      redirect_to '/users/manage'
    else
      @save_errors = ''
      @user.errors.messages.each_key { |key| @save_errors << "#{key} #{@user.errors.messages[key][0]}" }
      render 'edit'
    end
  end

  #delete /users/manage/:id
  def destroy
    @user.destroy
    redirect_to action: 'index'
  end

  private

  def find_user
    @user = User.where('id = ?', params[:id]).first
  end

  def check_permission
    unless current_user.is_admin
      render 'permission_error', status: 403
    end
  end

  def set_active
    @active = 'users'
  end
end
