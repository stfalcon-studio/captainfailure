class NotificationsSchedule < ActiveRecord::Base
  belongs_to :notification
  validates :m, :h, :dom, :mon, :dow, presence: true
end
