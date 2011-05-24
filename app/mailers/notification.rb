class Notification < ActionMailer::Base
  default :from => "#{Settings.app_name} <noreply@#{WEB_HOST}>"

  # Notification.password_reset_instructions(user).deliver
  #
  def password_reset_instructions(user)
    @edit_password_reset_url = edit_password_reset_url(user.perishable_token)
    mail(:subject => setup_subject(I18n.t('password_reset_instructions')),
         :to => user.email)
  end

  def activation_instructions(user)
    @account_activation_url = register_url(user.perishable_token)
    mail(:subject => setup_subject(I18n.t('please_activate_your_account')),
         :to => user.email)
  end

  def new_tender_message(order, email)
    @order = order
    mail(:subject => setup_subject("Новая заявка для вашего заказа"),
         :to => email)
  end


  # Sent when a user's account activation is completed.
  def activation_confirmation(user)
    @root_url = root_url
    mail(:subject => setup_subject(I18n.t('activation_complete')),
         :to => user.email)
  end

  # подтверждение смены почты
  def email_confirmation(id,new_email)
    @conf_email = "http://#{WEB_HOST}/activations/actemail?token=#{User.find(id).persistence_token}&email=#{new_email}"
    mail(:subject => setup_subject("Email confirmation"),
         :to => new_email)
  end

  def remote_upload(email, user, track, options)
    @track = track
    @double_track_url = track_url(options[:double_track]) unless options[:double_track].blank?
    @track_url =  options[:track_url]
    mail(:subject => setup_subject("Ошибка удаленной загрузки файла"), :to => email)
  end


  private

  def setup_subject(subj)
    "#{Settings.app_name} | #{subj}"
  end

end
