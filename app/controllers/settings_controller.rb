class SettingsController < ApplicationController

  before_action :check_permission
  before_action :set_active
  before_action :find_rabbitmq, only: [:rabbitmq, :rabbitmq_update]
  before_action :find_turbosms, only: [:turbosms, :turbosms_update]
  before_action :find_general, only:  [:general, :general_update]

  def index
    redirect_to action: general
  end

  def general
    @container_active = 'general'
  end

  def general_update
    param = params.require(:setting).permit(:reports_days_to_store)
    @setting.update_attributes(param)
    if @setting.errors.empty?
      flash[:notice] = 'Successfully saved.'
      redirect_to action: general
    else
      flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      render 'general'
    end
  end

  def rabbitmq
    @container_active = 'rabbitmq'
  end

  def rabbitmq_update
    param = params.require(:setting).permit(:host, :port, :user, :password)
    @setting.update_attributes(param)
    if @setting.errors.empty?
      flash[:notice] = 'Successfully saved.'
      redirect_to action: rabbitmq
    else
      flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      render 'rabbitmq'
    end
  end

  def turbosms
    @container_active = 'turbosms'
  end

  def turbosms_update
    param = params.require(:setting).permit(:user, :password, :name_in_sms)
    @setting.update_attributes(param)
    if @setting.errors.empty?
      flash[:notice] = 'Successfully saved.'
      redirect_to action: turbosms
    else
      flash.now[:alert] = 'You made mistakes in your form. Please correct them.'
      render 'turbosms'
    end
  end

  private

  def check_permission
    unless current_user.is_admin
      render 'permission_error', status: 403
    end
  end

  def set_active
    @active = 'settings'
  end

  def find_general
    @setting = Setting.where(name: 'general').first
    render text: 'Not found', status: 404 unless @setting
  end

  def find_rabbitmq
    @setting = Setting.where(name: 'rabbitmq').first
    render text: 'Not found', status: 404 unless @setting
  end

  def find_turbosms
    @setting = Setting.where(name: 'turbosms').first
    render text: 'Not found', status: 404 unless @setting
  end

end
