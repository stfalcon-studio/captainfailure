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

end
