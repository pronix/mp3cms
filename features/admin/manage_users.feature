# language: ru
 Функционал: Управление Пользователями
   Настройка пользователей
   Администратор должен иметь возможность добавлять, удалять и редактировать пользователей.

   Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
     И в сервисе есть следующие пользователи:
     | id | login | email                | password | active | roles       | balance |
     |  1 | admin | admin_user@gmail.com | secret   | true   | admin       |       0 |
     |  2 | anna  | anna@gmail.com       | secret   | true   | user        |      23 |
     |  3 | petr  | petr@gmail.com       | secret   | true   | user        |      43 |
     # И загружены следующие треки:
     # | title              | author       | playlist | user_email     | state      |
     # | Музыка нас связала | Мираж        | Попса    | petr@gmail.com | active     |
     # | Наше время пришло  | Комиссар     | Попса    | petr@gmail.com | active     |
     # | Городские встречи  | С. Наговицын | Шансон   | petr@gmail.com | moderation |
     # | Девочка-проказница | С. Наговицын | Шансон   | petr@gmail.com | moderation |
     # | Wind of change     | Scorpions    | Разное   | anna@gmail.com | banned     |
     # | Send Me An Angel   | Scorpions    | Разное   | anna@gmail.com | banned     |
     И зашел в сервис как "admin_user@gmail.com/secret"

  Сценарий: Список пользователей
    Допустим я перешел на страницу "admin_users"
    То я увижу табличные данные в ".users_table":
      | Id | Login | Email                | Balance    | Add files | Download files | Role  | Actions                     |
      |  1 | admin | admin_user@gmail.com | 0.00 руб.  | add_files | download_files | admin | Редактировать Удалить Block |
      |  2 | anna  | anna@gmail.com       | 23.00 руб. | add_files | download_files | user  | Редактировать Удалить Block |
      |  3 | petr  | petr@gmail.com       | 43.00 руб. | add_files | download_files | user  | Редактировать Удалить Block |


  Сценарий: Просмотр учетной записи пользователя
  Сценарий: Редактирование пользователя
  Сценарий: Блокировка пользователя
  Сценарий: Удаление пользователя

  # Сценарий: Редактирование данных пользователя
  #   Допустим Я перешел на странице редактирования пользователя "free_user@gmail.com"
  #   Если Я изменил поле "user[name]" на значение "new_nickname"
  #   И нажал кнопку "Save"
  #   То Я должен увидеть сообщение "User was successfully updated."

  # Сценарий: Удаление пользователя
  #   Допустим у пользователя "free_user@gmail.com" нет задач
  #   И перешел на страницу "users"
  #   И должен увидеть таблицу пользователей:
  #    | Login                | Added date       | Tasks | Actions     |
  #    | admin_user@gmail.com | 20.01.2010 15:09 | 12/3  | Edit Delete |
  #    | free_user@gmail.com  | 12.12.2009 12:24 | 0/0   | Edit Delete |
  #   Если Я удаляю пользователя "free_user@gmail.com"
  #   То Я должен увидеть таблицу пользователей:
  #    | Login                | Added date       | Tasks | Actions     |
  #    | admin_user@gmail.com | 20.01.2010 15:09 | 12/3  | Edit Delete |

