Recaptcha.configure do |config|
  config.public_key =  Settings.recaptcha[:pub]
  config.private_key =  Settings.recaptcha[:priv]
end
