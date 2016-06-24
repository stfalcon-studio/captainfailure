#!/usr/bin/env ruby

require 'bunny'
require 'json'

class SatelliteChecker
  def initialize
    require 'socket'
    require 'timeout'
    @instance ||= self
  end
  class << self
    def icmp_check(ip, icmp_count)
      system("ping -c #{icmp_count} #{ip}")
    end

    def port_check(ip, port, timeout)
      begin
        Timeout::timeout(timeout) do
          begin
            s = TCPSocket.new(ip, port)
            s.close
            return true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            return false
          end
        end
      rescue Timeout::Error
        return false
      end
      return false
    end

    def http_code_check(uri, code_expected, timeout, headers = nil)
      require 'httpclient'
      client = HTTPClient.new
      begin
        Timeout::timeout(timeout) do
          begin
            if headers
              result = client.get(uri, nil, headers)
            else
              result = client.get(uri)
            end
            if result.code == code_expected
              return true
            else
              return false
            end
          rescue
            return false
          end
        end
      rescue Timeout::Error
        return false
      end
    end

    def http_keyword_check(uri, code_expected, keyword, timeout, headers = nil)
      require 'httpclient'
      client = HTTPClient.new
      begin
        Timeout::timeout(timeout) do
          begin
            if headers
              result = client.get(uri, nil, headers)
            else
              result = client.get(uri)
            end
            if (result.code == code_expected) and (result.content.include?(keyword))
              return true
            else
              return false
            end
          rescue
            return false
          end
        end
      rescue Timeout::Error
        return false
      end
    end

    def resolve_domain(domain)
      Socket::getaddrinfo(domain, Socket::SOCK_STREAM)[0][3]
    end

    def run_in_thread(opts, satellite_name, check_request)
      Thread.new(opts, satellite_name, check_request) do |rabbitmq_opts, satellite, check|
        if check['check_via'] == 'domain'
          check['ip'] = SatelliteChecker.resolve_domain(check['domain'])
        end
        if check['check_type'] == 'icmp'
          result = SatelliteChecker.icmp_check(check['ip'], check['icmp_count'])
        elsif check['check_type'] == 'port_open'
          result = SatelliteChecker.port_check(check['ip'], check['tcp_port'], check['timeout'])
        elsif check['check_type'] == 'http_code'
          uri = "#{check['http_protocol']}://#{check['http_vhost']}:#{check['tcp_port']}#{check['http_uri']}"
          if check['http_headers']
            result = SatelliteChecker.http_code_check(uri, check['http_code'], check['timeout'], check['http_headers'])
          else
            result = SatelliteChecker.http_code_check(uri, check['http_code'], check['timeout'])
          end
        elsif check['check_type'] == 'http_keyword'
          uri = "#{check['http_protocol']}://#{check['http_vhost']}:#{check['tcp_port']}#{check['http_uri']}"
          if check['http_headers']
            result = SatelliteChecker.http_keyword_check(uri, check['http_code'], check['http_keyword'], check['timeout'], check['http_headers'])
          else
            result = SatelliteChecker.http_keyword_check(uri, check['http_code'], check['http_keyword'], check['timeout'])
          end
        end
        report = {}
        report[:result] = result
        report[:check_result_id] = check['check_result_id']
        report[:satellite] = satellite
        report[:check_time] = Time.now.utc
        send_report(rabbitmq_opts, report)
      end
    end

    def send_report(rabbitmq_opts, report)
      conn = Bunny.new(rabbitmq_opts)
      conn.start
      ch = conn.create_channel
      q  = ch.queue('captainfailure_reports')
      q.publish(report.to_json, :persistent => true)
      conn.close
    end
  end
end

opts = {host: '127.0.0.1', username: 'captainfailure', password: 'qwerty'}
satellite_name = 'example'
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
    SatelliteChecker.run_in_thread(opts, satellite_name, check)
  end
rescue Interrupt => _
  ch.close
  conn.close
end
