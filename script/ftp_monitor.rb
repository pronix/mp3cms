#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require File.expand_path( File.join( File.dirname(__FILE__), '..', 'config', 'environment' ) )
require 'rubygems'
require 'rb-inotify'
require 'mp3info'
require 'daemon_spawn'

class FtpMonitor < DaemonSpawn::Base

  def start(args)

    notifier = INotify::Notifier.new
    watch_path = Settings[:ftp_path]

    notifier.watch(watch_path, :close_write, :moved_to, :recursive) do |event|
      begin
        puts "=========== monitor ftp folder ======================================================"
        file_path  = event.absolute_name
        file_name  = File.basename(event.absolute_name)
        user_email = File.split(File.dirname(event.absolute_name)).last
        tmp_path   = File.join(File.dirname(event.absolute_name), "#{file_name}")

        puts '-'*90
        puts "upload file on ftp #{event.absolute_name}"

        if (user = User.find_by_email(user_email))
          # если в данный момент все загрузки на основной сервер - то заливаем на него
          # если какой-то сателлит назначен основным то заливаем на него

          Mp3Info.open(tmp_path) do |mp3|
            title  = mp3.tag.title.try(:to_utf8) || file_name
            author = mp3.tag.artist.try(:to_utf8) || "user: - #{user.login}"
            track = user.tracks.new({ :data => File.open(tmp_path).binmode,
                                      :title => title ,
                                      :satellite_id => Satellite.f_master.id ,
                                      :author => author })
            if track.valid?
              track.save!
            else
              puts "track is not valid : #{ track.errors.inspect }"
            end
          end

        else
          puts "not found user for email: #{user_email}"
        end

        FileUtils.rm_rf tmp_path
      rescue => e
        puts e
        puts  " #{$!.inspect} "
      end

    end

    notifier.run

  end

  def stop
    puts "stop ftp monitor"
  end
end
FtpMonitor.spawn!(:log_file => File.join(RAILS_ROOT, "log", "ftp_monitor.log"),
                  :pid_file => File.join(RAILS_ROOT, 'tmp', 'pids', 'ftp_monitor.pid'),
                  :sync_log => true,
                  :working_dir => RAILS_ROOT)
