module ServersHelper
  def notification_fail_count(server_id, notification_id)
    server_notification = ServerNotification.where(server_id: server_id, notification_id: notification_id).first
    server_notification.fail_to_notify_count
  end
end
