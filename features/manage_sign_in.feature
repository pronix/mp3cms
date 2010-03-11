# language: ru
Функционал: Вход
  Для доступа к сервису
  Пользователь должен иметь возможность аутентификации в сервисе

  Предыстория:
    Допустим в сервисе есть слеующие роли пользоватлей:
     | name      | system | description   |
     | admin     | true   | administrator |
     | user      | true   | users         |
     | moderator | true   | moderators    |
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |
     | test  | new_user@gmail.com   | secret   | true   | user        |

  Сценарий: Пользователь зарегистрирован
    Допустим я на главной странице сервиса
    Если я перешел на страницу "login"
    И введу в поле "user_session[email]" значение "new_user@gmail.com"
    И введу в поле "user_session[password]" значение "secret"
    И нажму "Login"
    То я буду на "главной странице сервиса"
    И увижу ссылку на учетную запись для "new_user@gmail.com"
    И увижу ссылку на выход из сервиса


  Сценарий: Вход не зарегистрированного пользователя
    Допустим я на главной странице сервиса
    Если я перешел на страницу "login"
    И введу в поле "user_session[email]" значение "tt_user@gmail.com"
    И введу в поле "user_session[password]" значение "secret"
    И нажму "Login"
    То я увижу "E-mail is not valid"

  Сценарий: Пользователь вводит неправильный пароль
    Допустим я на главной странице сервиса
    Если я перешел на страницу "login"
    И введу в поле "user_session[email]" значение "new_user@gmail.com"
    И введу в поле "user_session[password]" значение "secret1"
    И нажму "Login"
    То я увижу "Password is not correct"

  Сценарий: Вход не активированного пользователя
    Допустим в сервисе есть следующие пользователи:
     | login | email                  | password | active | roles |
     | test  | test_user@gmail.com    | secret   | false  | user  |
    Если я перешел на страницу "login"
    И введу в поле "user_session[email]" значение "test_user@gmail.com"
    И введу в поле "user_session[password]" значение "secret"
    И нажму "Login"
    То я увижу "Your account is not active"

  Сценарий: Вход забанненого пользователя
    Допустим пользователя "new_user@gmail.com" забанили
    Если я перешел на страницу "login"
    И введу в поле "user_session[email]" значение "new_user@gmail.com"
    И введу в поле "user_session[password]" значение "secret"
    И нажму "Login"
    То я увижу
    """
Ваша учетная запись заблокирована.На Вас нажаловались за популязацию Rammstain.Учетная запись будет разблокирована 01.05.2010
    """

