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
    STDOUT.puts 'Done!'.green
  end

  desc 'Run checks on satellites'
  task run_checks: :environment do
    require 'bunny'
    rabbitmq_settings = Setting.where(name: 'rabbitmq').first
    rabbitmq_connection = Bunny.new(host: rabbitmq_settings.host, port: rabbitmq_settings.port,
                                    username: rabbitmq_settings.user, password: rabbitmq_settings.password)
    Check.all.each do |check|
      if (Time.now.utc - check.updated_at > check.check_interval.to_i.minutes) and check.enabled
        p check
        check.updated_at = Time.now.utc
        check.save
      end
    end
  end

end
