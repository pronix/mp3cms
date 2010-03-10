module UserHelpers
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
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
  user.has_role?(role_name.to_sym).should be_true
end

Then /^пользователь "([^\"]*)" должен быть не активным$/ do |user_login|
  user = User.find_by_login user_login
  user.should_not be_nil
  user.active?.should be_false
end
