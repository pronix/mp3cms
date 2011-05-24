require 'bundler/capistrano'
require "delayed/recipes"

# создание директорий для ftp, rrd
default_run_options[:pty] = true
set :application, "mp3cms"

set :scm, :git
set :repository,  "git@github.com:pronix/mp3cms.git"
set :ssh_options, {:forward_agent => true}
set :branch, "rails3"

set :user, "root"
# set :bundle_flags,       "--quiet"
set :keep_releases, 3
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"
set :use_sudo, false
set :rails_env, "production"

role :app, "194.28.172.111"
role :web, "194.28.172.111"
role :db,  "194.28.172.111" , :primary => true

set(:shared_database_path) {"#{shared_path}/databases"}
#set(:ruby_path,"/opt/ruby-enterprise-1.8.7-2010.01/bin")




before 'deploy:setup','deploy:sshfs_install'
before 'deploy:chown','deploy:umount_sshfs'

namespace :deploy do
  desc "install sshfs for mount remote fs over ssh"
  task :sshfs_install, :roles => :app do
    run 'yum install fuse-sshfs net-snmp-utils -y '
  end

  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with passenger"
    task t, :roles => :app do ; end
  end

  desc "umount sshfs"
  task :umount_sshfs, :roles => :app do
    run "fusermount -u \`mount | grep -i sshfs | awk '{print $3}'\`" rescue ''
  end

  task :chown, :roles => :app do
    run "chown apache:apache #{current_path}/"
    run  "chmod -R 777 /var/www/mp3cms/current/log/search*"
  end

  desc "create symlinks on shared resources"
  task :symlinks do
    run "mkdir -p #{shared_path}/data" unless File.exist?("#{shared_path}/data")
    run "ln -nfs #{shared_path}/data #{release_path}/data "
    run "chown apache:apache #{release_path}/data -R"
    %w{assets playlists news rrd}.each do |share|
      run "ln -nfs #{shared_path}/public/#{share} #{release_path}/public/#{share} "
      run "chown apache:apache #{release_path}/public/#{share} -R"
    end
    run "chown apache:apache #{release_path}/tmp -R"
    run "chmod 777 #{release_path}/tmp "

    run "ln -nfs #{shared_path}/database.yml #{current_path}/config/database.yml "

  end
  desc "restart ftp server"
  task :restart_vsftpd do
    run "/etc/init.d/vsftpd restart"
  end

  desc " Generate Tag Cloud"
  task :generate_tag_cloud, :roles => :app do
    # run "cd #{current_path}; RAILS_ENV=production bundle exec script/rails runner 'TagCloud.generate' "
  end

end
namespace :ftp_monitor do
  desc "Start ftp monitor"
  task :start, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec ./script/ftp_monitor.rb start"
  end
  desc "Stop ftp monitor"
  task :stop, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec ./script/ftp_monitor.rb stop"
  end

  desc "Restart ftp monitor"
  task :restart, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=production bundle exec ./script/ftp_monitor.rb restart"
  end

end



set :sphinx_role, :app


namespace :thinking_sphinx do

  desc "Starts the thinking sphinx searchd server"
  task :start, :roles => sphinx_role do
    puts "Starting thinking sphinx searchd server"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake thinking_sphinx:configure"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake ts:start"
  end

  desc "Stops the thinking sphinx searchd server"
  task :stop, :roles => sphinx_role do
    puts "Stopping thinking sphinx searchd server"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake thinking_sphinx:configure"
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake ts:stop"
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
    run "cd #{current_path}; RAILS_ENV=production bundle exec rake ts:index"
  end
end

namespace :whenever do
  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && whenever --update-crontab #{application}"
  end
end


after "deploy:update",  "deploy:symlinks", "deploy:chown", "whenever:update_crontab", "deploy:restart_vsftpd"
# after "deploy:update_code", "thinking_sphinx:symlink_config" # sym thinking_sphinx.yml on update code
after "deploy:restart"    , "thinking_sphinx:restart"     # restart thinking_sphinx on app restart
after "thinking_sphinx:start","deploy:chown"
after "thinking_sphinx:restart","deploy:chown"
after "whenever:update_crontab", "deploy:generate_tag_cloud"
after "deploy:update", "deploy:cleanup"
after "deploy:restart", "ftp_monitor:restart"

# Build the SASS Stylesheets
before "deploy:restart" do
  run "cd #{current_path} && rake RAILS_ENV=#{rails_env} sass:build"
end
