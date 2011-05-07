require File.expand_path('../boot', __FILE__)

module Mp3cm
  class Application < Rails::Application
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
end
