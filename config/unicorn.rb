# Set the working application directory
# working_directory "/path/to/your/app"
working_directory '/home/captainfailure/captainfailure'

# Unicorn PID file location
# pid "/path/to/pids/unicorn.pid"
pid "/home/captainfailure/unicorn.pid"

# Path to logs
# stderr_path "/path/to/log/unicorn.log"
# stdout_path "/path/to/log/unicorn.log"
stderr_path "/home/captainfailure/captainfailure/log/stdout.log"
stdout_path "/home/captainfailure/captainfailure/log/stderr.log"

# Unicorn socket
listen "/tmp/unicorn.myapp.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30