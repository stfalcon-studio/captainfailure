#!/usr/bin/env ruby

require 'bunny'
require 'json'

class SatelliteChecker
  def initialize
    require 'net/ping'
    @instance ||= self
  end
  class << self
    def icmp_check(ip, icmp_count)
      system("ping -c #{icmp_count} #{ip}")
    end

    def resolve_domain(domain)
      Socket::getaddrinfo(domain, Socket::SOCK_STREAM)[0][3]
    end

    def send_report(rabbitmq_opts, report)
      conn = Bunny.new(rabbitmq_opts)
      conn.start
      ch = conn.create_channel
      q  = ch.queue('captainfailure_reports')
      q.publish(report.to_json, :persistent => true)
    end
  end
end

opts = {host: '54.229.102.49', username: 'captainfailure', password: 'LNRtFp3ekoIc3nTuzaZ1'}
satellite_name = 'aws-ierland'
conn = Bunny.new(opts)
conn.start

ch  = conn.create_channel
x   = ch.direct('captainfailure')
q   = ch.queue('', :exclusive => true)
q.bind(x, :routing_key => satellite_name)

puts ' [*] Waiting for checks. To exit press CTRL+C'

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    check = JSON.parse(body)
    puts " [x] #{delivery_info.routing_key}:#{body}"
    if check['check_via'] == 'domain'
      check['ip'] = SatelliteChecker.resolve_domain(check['domain'])
    end
    if check['check_type'] == 'icmp'
      result = SatelliteChecker.icmp_check(check['ip'], check['icmp_count'])
    end
    report = {}
    report[:result] = result
    report[:check_result_id] = check['check_result_id']
    report[:satellite] = satellite_name
    report[:check_time] = Time.now.utc
    SatelliteChecker.send_report(opts, report)
  end
rescue Interrupt => _
  ch.close
  conn.close
end