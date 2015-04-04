# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'catcher'
set :repo_url, 'git@github.com:645383/catcher.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/catcher'

# Default value for :scm is :git
set :scm, :git
set :branch, "master"
set :user, "deployer"
set :use_sudo, true
set :rails_env, "production"
set :deploy_via, :copy
# set :passenger_restart_with_sudo, true
# set :pty, true
# set :ping_url, "http://localhost"
# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do
  # task :start do
  #   ;
  # end
  # task :stop do
  #   ;
  # end

  desc "Symlink shared config files"
  task :symlink_config_files do
    on roles(:app) do
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      execute "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
    end
  end

  desc 'Restart application'
  task :restart do
      on roles(:app), in: :sequence, wait: 5 do
        execute :sudo, "service nginx restart"
      end
    end
  #
  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute "mkdir -p #{release_path.join('tmp')}"
  #     execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end
  #
  # after :publishing, :restart
  #
  # desc 'Warm up the application by pinging it, so enduser wont have to wait'
  # task :ping do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     execute "curl -s -D - #{fetch(:ping_url)} -o /dev/null"
  #   end
  # end
  #
  # after :restart, :ping
  #
  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end
end

after "deploy", "deploy:symlink_config_files"
after "deploy", "deploy:restart"
# after "deploy", "deploy:cleanup"
