c = YAML::load(File.open("#{Rails.root}/config/email.yml"))
delivery_method = c[Rails.env]['email']['delivery_method']

case delivery_method
when /sendmail/
  ActionMailer::Base.delivery_method = :sendmail
when /test/
  ActionMailer::Base.delivery_method = :test
when /smtp/
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address        => c[Rails.env]['email']['server'],
    :port           => c[Rails.env]['email']['port'],
    :domain         => c[Rails.env]['email']['domain'],
    :authentication => c[Rails.env]['email']['authentication'],
    :user_name      => c[Rails.env]['email']['username'],
    :password       => c[Rails.env]['email']['password']
  }
end

SITE_ADMIN_EMAIL = c[Rails.env]['email']['site_admin_email']
WEB_HOST = c[Rails.env]['web_host']




