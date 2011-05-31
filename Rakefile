# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
module ::Mp3cms
  class Application
    include Rake::DSL
  end
end

Mp3cms::Application.load_tasks

