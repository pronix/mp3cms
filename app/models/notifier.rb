class Notifier < ActionMailer::Base
  default_url_options[:host] = WEB_HOST

  # Sent when a user requests a password reset.
  # Contains the link they follow back to the site with their token
  # so they can reset the password
  def password_reset_instructions(user)
    subject       "#{Settings[:APP_NAME]} #{I18n.t('password_reset_instructions')}"
    from          "#{Settings[:APP_NAME]} <noreply@#{WEB_HOST}>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end

  # Sent when a user first signs up
  # Contains a link back to the site which verifies the email
  # and then allows the user to set their password
  def activation_instructions(user)
    subject       "#{Settings[:APP_NAME]} #{ I18n.t('please_activate_your_account') }"
    from          "#{Settings[:APP_NAME]} <noreply@#{WEB_HOST}>"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => register_url(user.perishable_token)
  end

  def new_tender_message(order, email)
    subject       "Новая заявка для вашего заказа"
    from          "#{Settings[:APP_NAME]} <noreply@#{WEB_HOST}>"
    recipients    email
    sent_on       Time.now
    body          :order => order
  end

  # Sent when a user's account activation is completed.
  def activation_confirmation(user)
    subject       "#{Settings[:APP_NAME]} #{I18n.t('activation_complete')}"
    from          "#{Settings[:APP_NAME]} <noreply@#{WEB_HOST}>"
    recipients    user.email
    sent_on       Time.now
    body          :root_url => root_url
  end

  # подтверждение смены почты
  def email_confirmation(id,new_email)
    subject       "#{Settings[:APP_NAME]} Email confirmation"
    from          "#{Settings[:APP_NAME]} <noreply@#{WEB_HOST}>"
    recipients    new_email
    sent_on       Time.now
    body          :conf_email => "http://#{WEB_HOST}/activations/actemail?token=#{User.find(id).persistence_token}&email=#{new_email}"
  end

  def remote_upload(user, track, options)
    subject       "#{Settings[:APP_NAME]} Ошибка удаленной загрузки файла}"
    from          "#{Settings[:APP_NAME]} <noreply@#{WEB_HOST}>"
    recipients    user.email
    sent_on       Time.now
    body          :user => user, :track => track, :options => options

  end


end
