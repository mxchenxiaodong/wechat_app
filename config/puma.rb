# Load env virianles from .env
require "dotenv"
require "pathname"

dir = Pathname.new(File.dirname(__FILE__)).realpath
app_env = Dotenv.load("#{dir.parent.to_s}/.env")


environment app_env['WC_WEB_ENV_MODE']

workers Integer(app_env['WC_WEB_CONCURRENCY'] || 3)
threads_count = Integer(app_env['WC_WEB_MAX_THREADS'] || 100)
threads 2, threads_count

# TODO: use unix socket instead of using tcp
port app_env['WC_WEB_PORT']
rackup DefaultRackup


lowlevel_error_handler do |e|
  puts e.to_s
  [500, {'Content-Type' => 'text/html', 'Location' => '500.html'}, []]
end

on_restart do
	puts 'On restarting...'
end

daemonize(app_env['WC_WEB_ENV_MODE'] == "production")

preload_app!

# environment 'production'
# threads 2, 64
# workers 4

# app_name = ""
# application_path = "/home/www/#{app_name}"
# directory "#{application_path}/current"

# pidfile "#{application_path}/shared/tmp/pids/puma.pid"
# state_path "#{application_path}/shared/tmp/sockets/puma.state"
# stdout_redirect "#{application_path}/shared/log/puma.stdout.log", "#{application_path}/shared/log/puma.stderr.log"
# bind "unix://#{application_path}/shared/tmp/sockets/#{app_name}.sock"
# activate_control_app "unix://#{application_path}/shared/tmp/sockets/pumactl.sock"

# daemonize true
# on_restart do
#   puts 'On restart...'
# end
# preload_app!
