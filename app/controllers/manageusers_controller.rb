class ManageusersController < ApplicationController

  before_action :find_user, only: [:show, :edit, :update, :destroy]

  #get /users/manage
  def index
    @active = 'users'
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
    @user = User.create(params.require(:user).permit(:name, :email, :password, :password_confirmation))
    if @user.errors.empty?
      redirect_to '/users/manage'
    else
      render 'edit'
    end
  end

  #get /users/manage/:id
  def edit
  end

  #put /users/manage/:id
  def update
    if params[:user][:password] == '' and params[:user][:password_confirmation] == ''
      update_params = :name, :email
    else
      update_params = :name, :email, :password, :password_confirmation
    end
    @user.update_attributes(params.require(:user).permit(update_params))
    if @user.errors.empty?
      redirect_to '/users/manage'
    else
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
end
