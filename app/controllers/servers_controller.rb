class ServersController < ApplicationController

  before_action :set_active

  def index
    @servers = Server.all
  end

  def new

  end

  def edit

  end

  private

  def set_active
    @active = 'servers'
  end
end
