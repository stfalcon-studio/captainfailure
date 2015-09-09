class Notification < ActiveRecord::Base
  validates :value, presence: true, uniqueness: true
  enum notification_type: { email: 0, sms: 1, slack: 2 }
  has_many :server_notifications
  has_many :servers, through: :server_notifications
  has_many :notifications_schedules
  belongs_to :user

  before_destroy do |notification|
    ServerNotification.where(notification_id: notification.id).each { |server_notification| server_notification.delete }
  end

  def active?
    require_relative '../../lib/cron_parser/cron_parser'
    cron = CronParser.new
    return true if self.notifications_schedules.count == 0
    self.notifications_schedules.each do |ns|
      cron.cron_data = [ns.m, ns.h, ns.dom, ns.mon, ns.dow]
      return true if cron.can_run_now?
    end
    false
  end
end
