module CheckScheduleState
  extend ActiveSupport::Concern
  
  def active?
    require_relative '../../../lib/cron_parser/cron_parser'
    cron = CronParser.new
    return true if self.schedules.count == 0
    self.schedules.each do |ns|
      cron.cron_data = [ns.m, ns.h, ns.dom, ns.mon, ns.dow]
      return true if cron.can_run_now?
    end
    false
  end
end