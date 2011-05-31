# encoding: utf-8
require 'active_record/fixtures'
namespace :mp3cms do

  namespace :db do

    desc "Loading db/sample for mp3-cms"
    task :sample => :environment do
      ActiveRecord::Base.establish_connection(Rails.env.to_sym)
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      end

      Dir.glob(File.join(Rails.root, "db", 'sample', '*.{yml,csv}')).each do |fixture_file|
        puts "load: #{fixture_file}"
        Fixtures.create_fixtures("#{Rails.root}/db/sample",
                                 File.basename(fixture_file, '.*'))
        puts "loaded: #{fixture_file}"
      end
      Dir.glob(File.join(Rails.root, "db", 'sample', '*.rb')).each do |ruby_file|
        puts "load ruby: #{ruby_file}"
        load ruby_file
        puts "loaded ruby: #{ruby_file}"
      end
      puts "Sample data has been loaded"
    end

    desc "Loading db/default for mp3-cms"
    task :default => :environment do
      ActiveRecord::Base.establish_connection(Rails.env.to_sym)
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      end
      Dir.glob(File.join(Rails.root, "db", 'default', '*.{yml,csv}')).each do |fixture_file|
        puts "load: #{fixture_file}"
        Fixtures.create_fixtures("#{Rails.root}/db/default",
                                 File.basename(fixture_file, '.*'))
        puts "loaded: #{fixture_file}"
      end
      Dir.glob(File.join(Rails.root, "db", 'default', '*.rb')).each do |ruby_file|
        puts "load ruby: #{ruby_file}"
        load ruby_file
        puts "loaded ruby: #{ruby_file}"
      end

      puts "Default data has been loaded"
    end

  end

end
