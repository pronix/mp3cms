# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Specify gems that this application depends on and have them installed with rake gems:install

  config.gem 'thinking-sphinx',  :lib     => 'thinking_sphinx',  :version => '1.3.16'
  config.gem "formtastic", :source => 'http://gemcutter.org'
  config.gem 'authlogic',  :source => 'http://gemcutter.org'
  config.gem 'paperclip',  :source => 'http://gemcutter.org'
  config.gem "inherited_resources", :version => '=1.0.3'
  config.time_zone = 'UTC'


  config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
  config.i18n.default_locale = :en


end

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

APP_NAME="MP3 CMS"

