namespace :captainfailure do
  desc 'Creates new user'
  task add_user: :environment do
    require 'colorize'
    user = User.new
    STDOUT.puts 'Enter name of new user (e.g. Ivan Pupkin):'.green
    user.name = STDIN.gets.strip
    STDOUT.puts 'Enter email:'.green
    user.email = STDIN.gets.strip
    STDOUT.puts 'Enter password:'.green
    password = STDIN.gets.strip
    user.password = password
    user.password_confirmation = password
    STDOUT.puts 'Admin? (y/n)'.green
    is_admin = STDIN.gets.strip
    if is_admin == 'y'
      user.is_admin = true
    end
    STDOUT.puts "Name: #{user.name}\nEmail: #{user.email}\nAdmin: #{user.is_admin}".green
    STDOUT.puts 'All ok? (y/n)'.green
    choice = STDIN.gets.strip
    if choice == 'y'
      user.save
      if user.errors.empty?
        STDOUT.puts 'New user successfully created.'.green
      else
        user.errors.messages.each { |msg| STDOUT.puts "#{msg}".red }
      end
    else
      STDOUT.puts 'Canceled.'.red
    end
  end

  desc 'Load default settings'
  task default_settings: :environment do
    STDOUT.puts 'In progress...'.green
    Setting.create(name: 'rabbitmq', value: { host: 'localhost', port: 5672, user: 'guest', password: 'guest' } )
    Setting.create(name: 'turbosms', value: { user: '', password: '', name_in_sms: '' } )
    Setting.create(name: 'general', value: { reports_days_to_store: '30' } )
    STDOUT.puts 'Done!'.green
  end

  desc 'Run checks on satellites'
  task run_checks: :environment do
    require 'bunny'
    rabbitmq_settings = Setting.where(name: 'rabbitmq').first
    rabbitmq_connection = Bunny.new(host: rabbitmq_settings.host, port: rabbitmq_settings.port,
                                    username: rabbitmq_settings.user, password: rabbitmq_settings.password)
    rabbitmq_connection.start
    ch = rabbitmq_connection.create_channel
    rabbit = ch.direct('captainfailure')
    Check.all.each do |check|
      if (Time.now.utc - check.updated_at > check.check_interval.to_i.minutes) and check.enabled == 'yes'
        server = Server.where(id: check.server_id).first
        check_result = CheckResult.new
        check_result.server = server
        check_result.check = check
        check_result.total_satellites = server.satellites.count
        check_result.ready_satellites = 0
        check_result.save
        server.satellites.all.each do |satellite|
          msg = check.serializable_hash
          if msg['check_via'] == 'ip'
            msg['ip'] = server.ip_address
          else
            msg['domain'] = server.dns_name
          end
          msg['check_result_id'] = check_result.id
          rabbit.publish(msg.to_json, :routing_key => satellite.name)
        end
        check.updated_at = Time.now.utc
        check.save
      end
    end
  end

  desc 'Processing reports from satellites'
  task reports_processing: :environment do
    require 'json'
    require "#{Rails.root}/app/helpers/application_helper"
    rabbitmq_settings = Setting.where(name: 'rabbitmq').first
    rabbitmq_connection = Bunny.new(host: rabbitmq_settings.host, port: rabbitmq_settings.port,
                                    username: rabbitmq_settings.user, password: rabbitmq_settings.password)
    rabbitmq_connection.start
    ch = rabbitmq_connection.create_channel
    q  = ch.queue('captainfailure_reports')
    q.subscribe(:ack => true, :block => true) do |delivery_info, properties, body|
      puts " [x] Received #{body}"
      report = JSON.parse(body)
      check_result = CheckResult.where(id: report['check_result_id']).first
      check_result.satellites_data << { name: report['satellite'], result: report['result'] }
      check_result.ready_satellites += 1
      check_result.save

      if check_result.total_satellites == check_result.ready_satellites
        server = Server.where(id: check_result.server_id).first
        success_count = 0
        check_result.satellites_data.each { |result| success_count += 1 if result[:result] }
        if server.alert_on == 0
          if success_count != 0
            check_result.passed = true
            check_result.check.fail_count = 0
            check_result.check.save
          else
            check_result.passed = false
            check_result.save
            check_result.check.fail_count += 1
            check_result.check.save
            ApplicationHelper::AlertSender.new(server, check_result)
          end
        else
          if success_count == check_result.total_satellites
            check_result.passed = true
            check_result.check.fail_count = 0
            check_result.check.save
          else
            check_result.passed = false
            check_result.save
            check_result.check.fail_count += 1
            check_result.check.save
            ApplicationHelper::AlertSender.new(server, check_result)
          end
        end
      end
      puts " [x] Done"

      ch.ack(delivery_info.delivery_tag)
    end
  end

  desc 'Clean old reports from satellites'
  task reports_clean: :environment do
    setting = Setting.where(name: 'general').first
    store_days = setting.reports_days_to_store.to_i
    CheckResult.where('updated_at <= ?', store_days.day.ago).each { |check_result| check_result.delete }
  end

end
