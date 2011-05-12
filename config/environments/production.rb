Mp3cms::Application.configure do
  config.cache_classes = true
  config.action_controller.consider_all_requests_local = false
  config.action_controller.perform_caching             = true

  config.log_level = :debug

  config.serve_static_assets = false
  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
  config.action_mailer.default_url_options = { :host => '320kbs.ru' }

end
