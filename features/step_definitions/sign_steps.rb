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
  _field = field[1..-1]
  if field.starts_with?('.')
    assert have_tag("input[class='#{_field}']").matches?(response_body), 'Нет такого поля'
  elsif field.starts_with?("#")
    assert have_tag("input[id='#{_field}']").matches?(response_body), 'Нет такого поля'
  else
    assert have_tag("input[name='#{field}']").matches?(response_body), 'Нет такого поля'
  end
end

Then /^(?:|я )увижу изображение капчи "(.*)"$/ do |img|
    _img = img[1..-1]
  if img.starts_with?('.')
    assert have_tag("img[class='#{_img}']").matches?(response_body), 'Нет такого поля'
  elsif img.starts_with?("#")
    assert have_tag("img[id='#{_img}']").matches?(response_body), 'Нет такого поля'
  else
    assert have_tag("img[name='#{img}']").matches?(response_body), 'Нет такого поля'
  end
end

Then /^(?:|я )увижу кнопку отправки формы "([^\"]*)"$/ do |field|
  _field = field[1..-1]
  if field.starts_with?('.')
    assert have_tag("input[class='#{_field}'][type='submit']").matches?(response_body), 'Нет такого поля'
  elsif field.starts_with?("#")
    assert have_tag("input[id='#{_field}'][type='submit']").matches?(response_body), 'Нет такого поля'
  else
    assert have_tag("input[type=submit][name='#{field}']").matches?(response_body), 'Нет такого поля'
  end
end
Given /^правильно ввел капчу$/ do
  test_code = ValidatesCaptcha.provider.class.symmetric_encryptor.encrypt "test_code"
  Given %(я введу в поле "user[captcha_solution]" значение "test_code")
  set_hidden_field "user[captcha_challenge]", :to => test_code
end



Then /^в сервисе должен появиться пользователь "([^\"]*)" с ролью "([^\"]*)"$/ do |user_login, role_name|
  user = User.find_by_login user_login
  user.should_not be_nil
  user.has_role?(role_name.strip.to_sym).should be_true
end

Then /^пользователь "([^\"]*)" должен быть не активным$/ do |user_login|
  user = User.find_by_login user_login
  user.should_not be_nil
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
    And %(правильно ввел капчу)
    And %(нажму "user_submit" в ".commit")

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
  When %(я буду на "главной странице сервиса")
   And %(увижу ссылку на учетную запись для "#{email}")
   And %(увижу ссылку на выход из сервиса)
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
  user.write_attribute(:updated_at, (Time.now-1.days).to_s(:db))
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

  if defined?(Spec::Rails::Matchers)
    response.should contain(text)
  else
    assert_contain text
  end
end

