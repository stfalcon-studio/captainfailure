class ChecksSchedulesController < SchedulesController
  before_action :find_check
  before_action :set_parent_controller
  before_action :find_schedule, only: [:edit, :update, :destroy]

  def index
    server_name = Server.where(id: params[:server_id]).first.dns_name
    @schedule_name = "#{server_name} check"
  end

  def schedule_polymorphic_path(object)
    "/servers/#{params[:server_id]}/checks/#{object.id}/checks_schedules"
  end

  private

  def find_check
    @schedulable_model = Check.where(id: params[:check_id]).first
    render_404 unless @schedulable_model
  end

  def find_schedule
    @schedule = Schedule.where(id: params[:id]).first
    render_404 unless @schedule
  end

  def set_parent_controller
    @parent_controller = "servers/#{params[:server_id]}/checks"
  end

end
