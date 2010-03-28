# language: ru
 Функционал: Учетная запись (Account)
   Управление учетной записью.
   Пользователь должен иметь возможность редактировать данные своей учеетной записи.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |
     | test  | new_user@gmail.com   | secret   | true   | user        |

  Сценарий: Если пользователь не заешел в сервис
    Допустим я перешел на страницу "account_path"
    То я буду на странице "login"
    И увижу "You must be logged in to access this page"

  Сценарий: Просмотр учетной записи
    Допустим я зашел в сервис как "new_user@gmail.com/secret"
    И перешел на страницу "account_path"
    То я увижу табличные данные в ".profile":
    | Login                     | test                |
    | Email                     | new_user@gmail.com  |
    | Всего заработано          | 0.00 $              |
    | Выплачено                 | 0.00 $              |
    | Осталось                  | 0.00 $              |
    | Количество залитых файлов | 0 (Cмотреть список) |

    # TODO убрал так как не в дизайне
    # И увижу ссылку "Редактировать"



  # Сценарий: Редактирование данных учетной записи
  #   Допустим я зашел в сервис как "new_user@gmail.com/secret"
  #   И перешел на страницу "account_path"
  #   Если я перейду по ссылке "Редактировать"
  #   И введу в поле "user[login]" значение "new_login"
  #   И нажму "Сохранить"
  #   То я буду на "account_path"
  #   И увижу "new_login"
  #   И увижу "Account was successfully updated"

