require "lib/blocking_ip"
Mp3cms::Application.config.middleware.use BlockingIp
