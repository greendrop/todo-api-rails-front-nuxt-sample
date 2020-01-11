# config valid for current version and patch releases of Capistrano
lock "~> 3.11.2"

set :application, 'todo-api-rails-front-nuxtjs-sample'
set :repo_url, 'https://github.com/greendrop/todo-api-rails-front-nuxtjs-sample.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp
set :branch, ENV['BRANCH'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, "/home/ap/apps/#{fetch(:application)}"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"
append :linked_files, '.env'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
append :linked_dirs, 'log'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# nodenv
set :nodenv_type, :user
set :nodenv_node, File.read('.node-version').strip
set :nodenv_prefix, "NODENV_ROOT=#{fetch(:nodenv_path)} NODENV_VERSION=#{fetch(:nodenv_node)} #{fetch(:nodenv_path)}/bin/nodenv exec"
set :nodenv_map_bins, %w[node npm yarn yarnpkg]
set :nodenv_roles, :all


namespace :yarn do
  desc 'Install'
  task :install do
    on roles(:app) do
      invoke 'yarn:install'
    end
  end
end

namespace :nuxt do
  desc 'Build'
  task :build do
    on roles(:app) do
      invoke 'nuxt:build'
    end
  end

  desc 'Restart'
  task :build do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'nuxt:restart'
    end
  end
end

after 'deploy:updated', 'yarn:install'
after 'yarn:install', 'nuxt:build'
after 'deploy:publishing', 'nuxt:restart'
