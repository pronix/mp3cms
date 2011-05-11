require "exception_notifier"
Mp3cms::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[ mp3cms ]",
  :sender_address => %{ "mp3cms" <notify@mp3.com>},
  :exception_recipients => %w{ parallel588@gmail.com }

