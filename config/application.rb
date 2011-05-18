require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)


require File.expand_path('../boot', __FILE__)

module Mp3cms
  class Application < Rails::Application

    config.action_view.javascript_expansions[:defaults] =
      if Rails.root =~ /production/i
        %w( jquery.min.js jquery-ui.min.js jquery_ujs.js jquery.pulse soundmanager2-nodebug-jsmin.js 320player.js)
      else
        %w( jquery.js jquery-ui.js jquery_ujs.js jquery.pulse soundmanager2.js 320player.js)
      end

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :ru

    config.time_zone = 'UTC'
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
  end



  ThinkingSphinx.suppress_delta_output = true
end
