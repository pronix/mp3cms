# создание директорий для ftp, rdd
default_run_options[:pty] = true
set :application, "mp3cms"

set :scm, :git
set :repository,  "git@github.com:pronix/mp3cms.git"
set :ssh_options, {:forward_agent => true}
set :branch, "master"

set :user, "root"

set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :rails_env, "production"

role :app, "mp3.adenin.ru"
role :web, "mp3.adenin.ru"
role :db,  "mp3.adenin.ru" , :primary => true

set(:shared_database_path) {"#{shared_path}/databases"}
set(:ruby_path,"/opt/ruby-enterprise-1.8.7-2010.01/bin")




namespace :deploy do
  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with passenger"
    task t, :roles => :app do ; end
  end

  task :chown, :roles => :app do
    run "chown -R apache:apache #{release_path}"
  end

  desc "create symlinks on shared resources"
  task :symlinks do
    run "mkdir -p #{shared_path}/data" unless File.exist?("#{shared_path}/data")
    run "ln -nfs #{shared_path}/data #{release_path}/data "
    %w{assets playlists }.each do |share|
      run "mkdir -p #{shared_path}/public/#{share}" unless File.exist?("#{shared_path}/public/#{share}")
      run "ln -nfs #{shared_path}/public/#{share} #{release_path}/public/#{share} "
    end

    run "ln -nfs #{shared_path}/database.yml #{current_path}/config/database.yml "

  end
  desc "restart ftp server"
  task :restart_vsftpddo
    run "/etc/init.d/vsftpd restart"
  end
end

namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => [:app] do
    begin
    run "/opt/ruby-enterprise-1.8.7-2010.01/bin/bluepill stop"
    run "/opt/ruby-enterprise-1.8.7-2010.01/bin/bluepill quit"
    rescue =>e
      puts e
    end
  end
  desc "Load bluepill configuration and start it"
  task :start, :roles => [:app] do
    run "touch #{shared_path}/pids/diskio.pid"
    run "touch #{shared_path}/pids/ftp_inotify.pid"
    run "touch #{shared_path}/pids/delayed_job.pid"
    run "chown -R apache:apache #{shared_path}"
    run "RAILS_ENV=production /opt/ruby-enterprise-1.8.7-2010.01/bin/bluepill load #{current_path}/config/bluepill/production.pill"
  end
  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    run "RAILS_ENV=production /opt/ruby-enterprise-1.8.7-2010.01/bin/bluepill status"
  end
end



after "deploy:update",  "deploy:symlinks", "deploy:chown",  "bluepill:quit", "bluepill:start", "deploy:restart_vsftpd"
