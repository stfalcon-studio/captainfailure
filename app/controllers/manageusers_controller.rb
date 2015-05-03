class ManageusersController < ApplicationController
  def index
    @active = 'users'
    @users = User.all
    render 'manageusers/index'
  end
end
