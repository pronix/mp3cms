# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
 set :cron_log, "/home/diman/NetBeansProjects/mp3cms/log/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# Индексидуем все змненения в bd для сфинкса
every 2.hours do
  rake "thinking_sphinx:index"
end

# Как только запустится крон, он запустит thinking_sphinx
every :reboot do
  rake "thinking_sphinx:start"
end

every 1.minutes do
  runner "TagCloud.generate", :environment => :development
end

# Генерирует облако тегов на основе последних запросов пользователей в поиске проекта.
every 1.day do
  runner "TagCloud.generate"
end

#every :friday, :at => "4am" do
#  command "rm -rf #{RAILS_ROOT}/tmp/cache"
#end

