# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# ExceptionNotifier.configure_exception_notifier do |config|
#   config[:app_name]                 = "mp3.adenin.ru"
#   config[:sender_address]           = "error@mp3.adenin.ru"
#   config[:exception_recipients]     = ["parallel588@gmail.com"]
#   config[:subject_prepend]          = "[#{(defined?(Rails) ? Rails.env : RAILS_ENV).capitalize} ERROR] "
#   config[:subject_append]           = nil
#   config[:sections]                 = %w(request session environment backtrace)
#   config[:notify_error_codes]   = %W( 405 500 503 )
#   config[:notify_other_errors]  = true
# end

