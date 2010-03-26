# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
#RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.middleware.use "BlockingIp"
  config.middleware.use "Download"

  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'ts-datetime-delta', :lib => 'thinking_sphinx/deltas/datetime_delta', :version => '>= 1.0.0', :source  => 'http://gemcutter.org'
  config.gem 'thinking-sphinx',  :lib     => 'thinking_sphinx',  :version => '1.3.16'
  config.gem "formtastic", :source => 'http://gemcutter.org'
  config.gem 'authlogic',  :source => 'http://gemcutter.org'
  config.gem 'paperclip',  :source => 'http://gemcutter.org'
  config.gem "inherited_resources", :version => '=1.0.3'
  config.gem 'validates_captcha'
  config.gem "declarative_authorization", :source => "http://gemcutter.org"
  config.gem 'jackdempsey-acts_as_commentable', :lib => 'acts_as_commentable', :source => "http://gems.github.com"
  config.gem 'rubyist-aasm', :lib => 'aasm', :source => "http://gems.github.com"
  config.gem 'ruby-mp3info', :lib => 'mp3info', :source => 'http://gemcutter.org'
  config.gem 'delayed_job', :lib => 'delayed_job', :source => 'http://gemcutter.org'
  config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
  config.gem 'chardet', :lib => 'UniversalDetector', :source => 'http://gemcutter.org'
  config.gem 'jrails', :lib => 'jrails', :source => 'http://gemcutter.org'
  config.gem "rubyzip", :version => '0.9.4', :lib => "zip/zip"
  config.gem "nokogiri", :version => '>=1.4.0'
  config.gem "fastercsv", :version => '1.5.0'
  config.gem "friendly_id", :version => '>= 2.3.2'
  config.gem "RedCloth",:version => '>= 4.2.3'
  config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'



  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  config.i18n.default_locale = :ru

  config.time_zone = 'UTC'
end

ThinkingSphinx.suppress_delta_output = true

# если ключь локализации не находит то сначала пытаеться вывести default потом  сам ключь в нормальном виде
module I18n
  class << self
    def just_raise_that_exception(exception, locale, key, options)
      return key.to_s.gsub('.',', ').humanize if I18n::MissingTranslationData === exception
      raise exception
    end
  end
end

I18n.exception_handler = :just_raise_that_exception

ValidatesCaptcha.provider = ValidatesCaptcha::Provider::DynamicImage.new
ValidatesCaptcha::StringGenerator::Simple.alphabet =(['0'..'9','A'..'Z', 'a'..'z'].map(&:to_a).flatten - ['O', 'o', "0", "1", "l"]).to_s
ValidatesCaptcha::StringGenerator::Simple.length = 3
Settings.load!

