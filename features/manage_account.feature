# language: ru
@green
 Функционал: Учетная запись (Account)
   Управление учетной записью.
   Пользователь должен иметь возможность редактировать данные своей учеетной записи.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(admin:true), user, moderator"
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |
     | test  | new_user@gmail.com   | secret   | true   | user        |

  Сценарий: Если пользователь не заешел в сервис
    Допустим я перешел на страницу "account_path"
    То я буду на странице "login"
    И увижу "Вы должны быть авторизорованны, для доступа к этой странице"

  Сценарий: Просмотр учетной записи
    Допустим я зашел в сервис как "new_user@gmail.com/secret"
    И перешел на страницу "account_path"
    То я увижу табличные данные в ".profile":
    | Всего заработано          | 0.00 $                   |
    | Выплачено                 | 0.00 $                   |
    | Осталось                  | 0.00 $                   |
    | Количество залитых файлов | 0                        |
    | Кошелёк                   | Вписать кошелёк          |
    |                           | Сменить email или пароль |
