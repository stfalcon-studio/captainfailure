class Notification < ActiveRecord::Base
  validates :value, presence: true, uniqueness: true
  enum notification_type: { email: 0, sms: 1 }
  has_many :server_notifications
  has_many :servers, through: :server_notifications
end
