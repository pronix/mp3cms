module UserHelpers
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end
  def set_current_user
    Authorization.current_user = current_user
  end
end
World(UserHelpers)

Then /^(?:|я )увижу поле "(.*)"$/ do |field|
  find_field(field).should be_present
end


Then /^(?:|я )увижу кнопку отправки формы "([^\"]*)"$/ do |field|
  find_button(field).should be_present
end

Then /^в сервисе должен появиться пользователь "([^\"]*)" с ролью "([^\"]*)"$/ do |user_email, role_name|
  user = User.find_by_email user_email
  user.should be_present
  user.has_role?(role_name.strip.to_sym).should be_true
end

Then /^пользователь "([^\"]*)" должен быть не активным$/ do |user_email|
  user = User.find_by_email user_email
  user.should be_present
  user.active?.should be_false
end
Given /^(?:|я )зарегистрировался в сервисе как "([^\"]*)"$/ do |email_password|
  email, password = email_password.split('/')
  Given %(я на главной странице сервиса)
    And %(перешел на страницу "Регистрации")
   Then %(я введу в поле "user[login]" значение "#{email}")
    And %(введу в поле "user[email]" значение "#{email}")
    And %(введу в поле "user[password]" значение "#{password}")
    And %(введу в поле "user[password_confirmation]" значение "#{password}")
    And %(нажму "user_submit")

end

Given /^(?:|я )учетная запись "([^\"]*)" еще не активирована$/ do |email_password|
  email, password = email_password.split('/')
  user = User.find_by_email(email)
  user.active = false
end

Given /^(?:|я )учетная запись "([^\"]*)" уже активирована$/ do |email_password|
  email, password = email_password.split('/')
  user = User.find_by_email(email)
  user.active = true
  user.save!
end

When /^(?:|я )перешел по ссылке которая была отправлена на почту "([^\"]*)"$/ do |address|
  When %(я открыл почту "#{address}")
   And %(перешел по первой ссылке в письме)
end

Then /^в сервисе учетная запись пользователя "([^\"]*)" должна стать активной$/ do |email_password|
  email, password = email_password.split('/')
  user = User.find_by_email(email)
  user.active?.should be_true
end

Given /^(?:|я )зашел в сервис как "([^\"]*)"$/ do |email_password|
  email, password = email_password.split('/')
  Given %(я на главной странице сервиса)
    And %(перешел на страницу "login")
  Then %(я введу в поле "user_session[email]" значение "#{email}")
   And %(введу в поле "user_session[password]" значение "#{password}")
   And %(нажму "Вход")
end

When /^должен быть авторизован как "([^\"]*)"$/ do |email_password|
  email, password = email_password.split('/')
  When %(я буду на "главной странице сервиса")
   And %(увижу ссылку на учетную запись для "#{email}")
   And %(увижу ссылку на выход из сервиса)
end

Then /^срок ссылки для пользователя "([^\"]*)" истек$/ do |user_email|
  user = User.find_by_email user_email
  User.record_timestamps = false
  user.send(:write_attribute, :updated_at, (Time.now-1.days).to_s(:db))
  user.save

end

When /^не должен быть авторизован/ do
  @current_user_session.should be_nil
end

When /^(?:|я )вышел из системы/ do
  visit logout_path
end

When /^я увижу сообщение ошибки "([^\"]*)" для поля "([^\"]*)" модели "([^\"]*)"$/ do |error, field, model|
  text =
    case model
    when /authlogic/i
      I18n.t("authlogic.error_messages.#{error}")
    when /^fm:/
    else
      I18n.t("activerecord.errors.models.user.attributes")[field.to_sym] ?  I18n.t("activerecord.errors.models.user.attributes.#{field.to_s}.#{error}") : I18n.t("activerecord.errors.messages.#{error}")
    end

  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

