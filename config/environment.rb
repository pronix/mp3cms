# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '2.3.11' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.middleware.use "BlockingIp"
  config.middleware.use "Download"

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
ValidatesCaptcha::StringGenerator::Simple.alphabet =(['0'..'9', 'a'..'z'].map(&:to_a).flatten - ['O', 'o', "0", "1", "l"]).to_s
ValidatesCaptcha::StringGenerator::Simple.length = 3


class ReverseString # very insecure and easily cracked
  def encrypt(code)
    code.reverse
  end

  def decrypt(encrypted_code)
    encrypted_code.reverse
  rescue => e
    nil
  end
end
ValidatesCaptcha::Provider::DynamicImage.symmetric_encryptor = ReverseString.new
ValidatesCaptcha.provider = ValidatesCaptcha::Provider::DynamicImage.new

Settings.load!

