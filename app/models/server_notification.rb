class ServerNotification < ActiveRecord::Base
  belongs_to :server
  belongs_to :notification
  validates_numericality_of :fail_to_notify_count, greater_than: 0
end
