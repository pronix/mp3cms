# создание директорий для ftp, rdd
default_run_options[:pty] = true
set :application, "mp3cms"

set :scm, :git
set :repository,  "git@github.com:pronix/mp3cms.git"
set :ssh_options, {:forward_agent => true}
set :branch, "test"

set :user, "root"

set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :rails_env, "production"

role :app, "mp3koza.com"
role :web, "mp3koza.com"
role :db,  "mp3koza.com" , :primary => true

set(:shared_database_path) {"#{shared_path}/databases"}
set(:ruby_path,"/bin")



before 'deploy:setup','deploy:sshfs_install'
namespace :deploy do
  desc "install sshfs for mount remote fs over ssh"
  task :sshfs_install, :roles => :app do
    run 'yum install fuse-sshfs'
  end

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
  task :restart_vsftpd do
    run "/etc/init.d/vsftpd restart"
  end
end

namespace :bluepill do
  desc "Stop processes that bluepill is monitoring and quit bluepill"
  task :quit, :roles => [:app] do
    begin
    run "/bin/bluepill stop"
    run "/bin/bluepill quit"
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
    run "RAILS_ENV=production /bin/bluepill load #{current_path}/config/bluepill/production.pill"
  end
  desc "Prints bluepills monitored processes statuses"
  task :status, :roles => [:app] do
    run "RAILS_ENV=production /bin/bluepill status"
  end
end

set :sphinx_role, :app


namespace :thinking_sphinx do

  desc "Starts the thinking sphinx searchd server"
  task :start, :roles => sphinx_role do
    puts "Starting thinking sphinx searchd server"
    run "cd #{current_path}; rake RAILS_ENV=production thinking_sphinx:configure"
    run "cd #{current_path}; rake RAILS_ENV=production ts:start"
  end

  desc "Stops the thinking sphinx searchd server"
  task :stop, :roles => sphinx_role do
    puts "Stopping thinking sphinx searchd server"
    run "cd #{current_path}; rake RAILS_ENV=production thinking_sphinx:configure"
    run "cd #{current_path}; rake RAILS_ENV=production ts:stop"
  end

  desc "Restarts the thinking sphinx searchd server"
  task :restart, :roles => sphinx_role do
    thinking_sphinx.stop
    thinking_sphinx.index
    thinking_sphinx.start
  end

  desc "Copies the shared/config/sphinx yaml to release/config/"
  task :symlink_config, :roles => :app do
    run "ln -s #{shared_path}/config/sphinx.yml #{release_path}/config/sphinx.yml"
  end

  desc "Displays the thinking sphinx log from the server"
    task :tail, :roles => :app do
      stream "tail -f #{shared_path}/log/searchd.log"
  end

  desc "Runs Thinking Sphinx indexer"
  task :index, :roles => sphinx_role do
    puts "Updating search index"
    run "cd #{current_path}; rake RAILS_ENV=production ts:index"
  end
end

namespace :whenever do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end


after "deploy:update",  "deploy:symlinks", "deploy:chown", "whenever:update_crontab", "bluepill:quit", "bluepill:start", "deploy:restart_vsftpd"
# after "deploy:update_code", "thinking_sphinx:symlink_config" # sym thinking_sphinx.yml on update code
after "deploy:restart"    , "thinking_sphinx:restart"     # restart thinking_sphinx on app restart
after "thinking_sphinx:start","deploy:chown"
after "thinking_sphinx:restart","deploy:chown"
