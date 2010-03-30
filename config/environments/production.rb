# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!
# ExceptionNotifier.exception_recipients = %w(parallel588@gmail.com)
ExceptionNotifier.configure_exception_notifier do |config|
  config[:exception_recipients]     = %w(parallel588@gmail.com)
end

ExceptionNotifier.configure_exception_notifier do |config|
  config[:app_name]                 = "mp3.adenin.ru"
  config[:sender_address]           = "error@mp3.adenin.ru"
  config[:exception_recipients]     = ["parallel588@gmail.com", "burovik_tpu@mail.ru"]
  config[:subject_prepend]          = "[MP3KOZA - #{(defined?(Rails) ? Rails.env : RAILS_ENV).capitalize} ERROR] "
  config[:subject_append]           = nil
  config[:sections]                 = %w(request session environment backtrace)
  config[:notify_error_codes]   = %W( 405 500 503 )
  config[:notify_other_errors]  = true
end
