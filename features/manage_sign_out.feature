# language: ru
Функционал: Выход из сервиса.
  Пользователь должен иметь возможность выйти из сервиса.


  Предыстория:
    Допустим в сервисе есть следующие роли пользователей:
     | name      | system | description   |
     | admin     | true   | administrator |
     | user      | true   | users         |
     | moderator | true   | moderators    |
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |
     | test  | new_user@gmail.com   | secret   | true   | user        |

  Сценарий: Пользователь выходит из сервиса
    Допустим я зашел в сервис как "new_user@gmail.com/secret"
    Если я перейду по ссылке "Выход"
    То я увижу "Надеемся, вы нас ещё посетите!"
    И я буду на "главной странице сервиса"
    И увижу ссылку "Регистрация"
    И увижу ссылку "Вход"

