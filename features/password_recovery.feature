# language: ru
Функционал: Восстановление пароля
  Пользователь должен иметь возможность восстановить свой пароль если забыл его

  Сценарий: На странице входа в сервис должна быть ссылка на востановление пароля
    Допустим я на главной странице сервиса
    Если я перешел на страницу "login"
    То я увижу "Восстановить пароль"

  Сценарий: Если пользователь нажал ссылку на востановления пароля то должен увидеть форму востановлени
    Допустим я на главной странице сервиса
    Если я перешел на страницу "login"
    И перейду по ссылке "Восстановить пароль"
    То я увижу поле "#email"
    И увижу кнопку отправки формы ".submit"

  Сценарий: Отправка пользователю ссылки на востановление пароля и изменени пароля
    Допустим в сервисе есть следующие роли пользователей:
     | name      | system | description   |
     | admin     | true   | administrator |
     | user      | true   | users         |
     | moderator | true   | moderators    |
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |
     | test  | new_user@gmail.com   | secret   | true   | user        |
    Если я перешел на страницу "password_resets"
    И введу в поле "email" значение "new_user@gmail.com"
    И нажму "Reset my password"
    И мой email "new_user@gmail.com"
    То будет уведомление "Instructions to reset your password have been emailed to you. Please check your email."
    И должен получить письмо на адрес "new_user@gmail.com"
    Если я открыл почту "new_user@gmail.com"
    И перешел по ссылке которая была отправлена на почту "new_user@gmail.com"
    И введу в поле "user[password]" значение "new_secret"
    И введу в поле "user[password_confirmation]" значение "new_secret"
    И нажму "Update password"
    То увижу "Your password has been reset"
    И должен быть авторизован как "new_user@gmail.com/new_secret"

  Сценарий: Отправка пользователю ссылки на востановление пароля и изменение пароля по истекшей ссылке
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator"
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |
     | test  | new_user@gmail.com   | secret   | true   | user        |
    Если я перешел на страницу "password_resets"
    И введу в поле "email" значение "new_user@gmail.com"
    И нажму "Reset my password"
    И мой email "new_user@gmail.com"
    То будет уведомление "Instructions to reset your password have been emailed to you. Please check your email."
    И должен получить письмо на адрес "new_user@gmail.com"
    Если срок ссылки для пользователя "new_user@gmail.com" истек
    И открыл почту "new_user@gmail.com"
    И перешел по ссылке которая была отправлена на почту "new_user@gmail.com"
    То я увижу
    """
    We're sorry, but we could not locate your account.If you are having issues try copying and pasting the URL from your email into your browser or restarting the reset password process.
    """
    И не должен быть авторизован

