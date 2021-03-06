# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'application_name'
set :repo_url, 'git@github.com:user_name/application_name.git'

set :rvm_type, :user                             # Defaults to: :auto
set :rvm_ruby_version, 'ruby-2.3.0@application_name' # Defaults to: 'default'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/srv/www/#{fetch(:application)}"

# set :passenger_in_gemfile, true
# set :passenger_restart_with_touch, false # Note that `nil` is NOT the same as `false` here

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

after 'deploy:publishing', 'thin:restart'
