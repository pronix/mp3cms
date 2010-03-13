# language: ru
Функционал: Управление полями пользователя
  Администратор должен иметь право добавлять, удалять и редактировать роли. Системные роли удалять нельзя.
  Другие пользователи не должны иметь доступ к ролям

  Предыстория:
    Допустим в сервисе есть следующие роли пользоватлей:
     | name      | system | description   | id | admin |
     | admin     | true   | administrator |  1 | true  |
     | user      | true   | users         |  2 | false |
     | moderator | true   | moderators    |  3 | false |
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |
     | test  | new_user@gmail.com   | secret   | true   | user        |

  Сценарий: Просмотр списка ролей администратором
    Допустим я зашел в сервис как "admin_user@gmail.com/secret"
    Если я перешел на страницу "admin_roles"
    То я увижу табличные данные в ".roles_table":
     | Id | Title     | Admin access | Users | Actions |
     |  1 | admin     | Yes          |     1 | edit    |
     |  2 | user      | No           |     2 | edit    |
     |  3 | moderator | No           |     0 | edit    |


  Сценарий: Попытка доступа к ролям не администратором
    Допустим я зашел в сервис как "new_user@gmail.com/secret"
    Если я перешел на страницу "admin_roles"
    То я увижу "Sorry, you are not allowed to access that page."

  Сценарий: Добавление новой роли пользователей с правами администратора
    Допустим я зашел в сервис как "admin_user@gmail.com/secret"
    Если я перешел на страницу "new_admin_role"
    И введу в поле "role[title]" значение "new role group"
    И нажму "Create role"
    То будет уведомление "Role was successfully created."
    И я должен быть на "admin_roles"
    И в сервисе должена появивться роль "new role group"

  Сценарий: Попытка добавления новой роли не администратором
    Допустим я зашел в сервис как "new_user@gmail.com/secret"
    Если я перешел на страницу "new_admin_role"
    То я увижу "Sorry, you are not allowed to access that page."

  Сценарий: Редактирование роли администратором
    Допустим я зашел в сервис как "admin_user@gmail.com/secret"
    Если я перешел на страницу "admin_roles"
    И перейду по ссылке "role_1"
    И введу в поле "role[title]" значение "super_admin"
    И нажму "Update role"
    То будет уведомление "Role was successfully updated."
    И у роль с ид "1" название должно быть "super_admin"

  @selenium
  Сценарий: Удаление роли администратором
    Допустим в сервисе есть следующие роли пользоватлей:
     | name        | system | description   | id | admin |
     | admin       | true   | administrator |  1 | true  |
     | user        | true   | users         |  2 | false |
     | moderator   | true   | moderators    |  3 | false |
     | custom_role | false  | custom roles  |  4 | false |
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |
     | test  | new_user@gmail.com   | secret   | true   | user        |
     И я зашел в сервис как "admin_user@gmail.com/secret"
    Если я перешел на страницу "admin_roles"
    И перейду по ссылке "Delete"
    То будет уведомление "Role was successfully destroyed."


