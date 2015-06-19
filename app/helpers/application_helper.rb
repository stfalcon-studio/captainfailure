module ApplicationHelper
  class AlertSender
    def initialize(server, check_result)
      @server = server
      @check_result = check_result
      send
    end

    private

    def send
      text = "Failed ICMP check to #{@server.dns_name}" if @check_result.check.check_type == 'icmp'
      text = "Port #{@check_result.check.tcp_port} closed on #{@server.dns_name}" if @check_result.check.check_type == 'port_open'
      text = "Failed #{@check_result.check.http_protocol}://#{@check_result.check.http_vhost}#{@check_result.check.http_uri} for #{@check_result.check.http_code} HTTP code on #{@server.dns_name}" if @check_result.check.check_type == 'http_code'
      text = "Failed #{@check_result.check.http_protocol}://#{@check_result.check.http_vhost}#{@check_result.check.http_uri} for #{@check_result.check.http_code} HTTP code and keyword #{@check_result.check.http_keyword} on #{@server.dns_name}" if @check_result.check.check_type == 'http_keyword'
      @server.notifications.each do |notification|
        notification_fail_count = notification_fail_count(@server.id, notification.id)
        if @check_result.check.fail_count >= notification_fail_count
          AlertMailer.send_alert(notification.value, @check_result.check.check_type, @server.dns_name, text).deliver_now
        end
      end

    end

    def notification_fail_count(server_id, notification_id)
      server_notification = ServerNotification.where(server_id: server_id, notification_id: notification_id).first
      server_notification.fail_to_notify_count
    end

  end

end
