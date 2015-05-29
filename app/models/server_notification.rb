class ServerNotification < ActiveRecord::Base
  belongs_to :server
  belongs_to :notification
end
