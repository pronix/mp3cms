# language: ru
Функционал: Регистрация пользователя
  Любой пользователь
  Должен иметь возможность зарегистрироваться в сервисе

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator"

  Сценарий: Поля которые должны быть показаны на форме регистрации
    Допустим я на главной странице сервиса
    И перешел на страницу "Регистрации"
    То я увижу форму ввода
    И увижу поле "#user_login"
    И увижу поле "#user_email"
    И увижу поле "#user_password"
    И увижу поле "#user_password_confirmation"
    И увижу поле "#user_icq"
    И увижу поле "#user_webmoney_purse"
    И увижу поле "#user_captcha_solution"
    И увижу изображение капчи "#user_captcha_image"
    И увижу кнопку отправки формы "#user_submit"

  Сценарий: Регистрация пользователя в сервисе только с основными данными.
    Допустим я на главной странице сервиса
    И перешел на страницу "Регистрации"
    Если я введу в поле "user[login]" значение "beer user"
    И введу в поле "user[email]" значение "new_user@gmail.com"
    И введу в поле "user[password]" значение "secret"
    И введу в поле "user[password_confirmation]" значение "secret"
    И правильно ввел капчу
    И нажму "user_submit" в ".commit"
    То будет уведомление "Ваш аккаунт был успешно создан. Пожалуйста, проверьте вашу почту для активации вашего аккаутна!"
    И должен получить письмо на адрес "new_user@gmail.com"
    И в сервисе должен появиться пользователь "beer user" с ролью "user"
    И пользователь "beer user" должен быть не активным

  Сценарий: Регистрация пользователя в сервисе с дополнительными данными
    Допустим я на главной странице сервиса
    И перешел на страницу "Регистрации"
    Если я введу в поле "user[login]" значение "beer user"
    И введу в поле "user[email]" значение "new_user@gmail.com"
    И введу в поле "user[password]" значение "secret"
    И введу в поле "user[password_confirmation]" значение "secret"
    И введу в поле "user[icq]" значение "7783404"
    И введу в поле "user[webmoney_purse]" значение "Z123443905434"
    И правильно ввел капчу
    И нажму "user_submit" в ".commit"
    То будет уведомление "Ваш аккаунт был успешно создан. Пожалуйста, проверьте вашу почту для активации вашего аккаутна!"
    И должен получить письмо на адрес "new_user@gmail.com"
    И в сервисе должен появиться пользователь "beer user" с ролью "user"
    И пользователь "beer user" должен быть не активным
    И в учетных данных пользователя "beer user" должны быть дополнительные данные:
    | icq            |       7783404 |
    | webmoney_purse | Z123443905434 |


  Сценарий: Регистрация пользователя с пустым login.
    Допустим я на главной странице сервиса
    И перешел на страницу "Регистрации"
    Если я введу в поле "user[login]" значение ""
    И нажму "user_submit" в ".commit"
    То я увижу сообщение ошибки "blank" для поля "login" модели "User"

  Сценарий: Регистрация пользователя с пустым password.
   Допустим я на главной странице сервиса
    И перешел на страницу "Регистрации"
    Если я введу в поле "user[password]" значение ""
    И нажму "user_submit" в ".commit"
    То я увижу сообщение ошибки "blank" для поля "password" модели "User"

  Сценарий: Регистрация пользователя с не подтвержденным password.
    Допустим я на главной странице сервиса
     И перешел на страницу "Регистрации"
     Если я введу в поле "user[password]" значение "secret"
     И я введу в поле "user[password_confirmation]" значение ""
     И нажму "user_submit" в ".commit"
     То я увижу сообщение ошибки "confirmation" для поля "password" модели "User"

  Сценарий: Регистрация пользователя с пустой капчей.
    Допустим я на главной странице сервиса
    И перешел на страницу "Регистрации"
    Если я введу в поле "user[login]" значение "beer user"
    И введу в поле "user[email]" значение "new_user@gmail.com"
    И введу в поле "user[password]" значение "secret"
    И введу в поле "user[password_confirmation]" значение "secret"
    И введу в поле "user[icq]" значение "7783404"
    И введу в поле "user[webmoney_purse]" значение "Z123443905434"
    И нажму "user_submit" в ".commit"
    То я увижу сообщение ошибки "blank" для поля "captcha_solution" модели "User"

  Сценарий: Регистрация пользователя с неправельной капчей.
    Допустим я на главной странице сервиса
    И перешел на страницу "Регистрации"
    Если я введу в поле "user[login]" значение "beer user"
    И введу в поле "user[email]" значение "new_user@gmail.com"
    И введу в поле "user[password]" значение "secret"
    И введу в поле "user[password_confirmation]" значение "secret"
    И введу в поле "user[icq]" значение "7783404"
    И введу в поле "user[webmoney_purse]" значение "Z123443905434"
    И введу в поле "user[captcha_solution]" значение "778"
    И нажму "user_submit" в ".commit"
    То я увижу сообщение ошибки "invalid" для поля "captcha_solution" модели "User"

  Сценарий: Регистрация пользователя с неверным кошельком вебмоней
    Допустим я на главной странице сервиса
    И перешел на страницу "Регистрации"
    Если я введу в поле "user[login]" значение "beer user"
    И введу в поле "user[email]" значение "new_user@gmail.com"
    И введу в поле "user[password]" значение "secret"
    И введу в поле "user[password_confirmation]" значение "secret"
    И введу в поле "user[icq]" значение "7783404"
    И введу в поле "user[webmoney_purse]" значение "R123443905434"
    И правильно ввел капчу
    И нажму "user_submit" в ".commit"
    То я увижу сообщение ошибки "invalid" для поля "webmoney_purse" модели "User"

  Сценарий: Подтверждение учетной записи пользователя.
    Допустим я зарегистрировался в сервисе как "new_user@gmail.com/secret"
    И учетная запись "new_user@gmail.com/secret" еще не активирована
    Если я перешел по ссылке которая была отправлена на почту "new_user@gmail.com"
    То я увижу "Активировать"
    Если я перейду по ссылке "Активировать"
    То я увижу "Ваш аккаунт был активорован."
    И в сервисе учетная запись пользователя "new_user@gmail.com" должна стать активной


  Сценарий: Пользователь повторно нажал на подтверждение учетной записи.
    Допустим я зарегистрировался в сервисе как "new_user@gmail.com/secret"
    И учетная запись "new_user@gmail.com/secret" уже активирована
    Если я перешел по ссылке которая была отправлена на почту "new_user@gmail.com"
    То я увижу "Срок регистрации истек"

