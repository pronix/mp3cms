# language: ru
 Функционал: Управление Пользователями
   Настройка пользователей
   Администратор должен иметь возможность добавлять, удалять и редактировать пользователей.

   Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
     И в сервисе есть следующие пользователи:
     | id | login | email                | password | active | roles | balance |
     |  1 | admin | admin_user@gmail.com | secret   | true   | admin |       0 |
     |  2 | anna  | anna@gmail.com       | secret   | true   | user  |      23 |
     |  3 | petr  | petr@gmail.com       | secret   | true   | user  |      43 |
     |  4 | vlad  | vlad@gmail.com       | secret   | true   | user  |      43 |
     И есть следующие плейлисты:
     | title   | description         | user_email     |
     | Попса   | Попсовая подборка   | petr@gmail.com |
     | Шансон  | Музыка шансон       | petr@gmail.com |
     | Разное  | Моя музыка          | anna@gmail.com |
     И загружены следующие треки:
     | title              | author       | playlist | user_email     | state      |
     | Музыка нас связала | Мираж        | Попса    | petr@gmail.com | active     |
     | Наше время пришло  | Комиссар     | Попса    | petr@gmail.com | active     |
     | Городские встречи  | С. Наговицын | Шансон   | petr@gmail.com | moderation |
     | Девочка-проказница | С. Наговицын | Шансон   | petr@gmail.com | moderation |
     | Wind of change     | Scorpions    | Разное   | anna@gmail.com | banned     |
     | Send Me An Angel   | Scorpions    | Разное   | anna@gmail.com | banned     |
     И пользователь "vlad@gmail.com" заблокирован
     И зашел в сервис как "admin_user@gmail.com/secret"

  Сценарий: Список пользователей
    Допустим я перешел на страницу "admin_users"
    То я увижу табличные данные в ".users_table":
      | Ид | Login | Email                | Баланс     | Добавил | Скачал         | Группа | Действия                      |
      |  1 | admin | admin_user@gmail.com | 0.00 руб.  |       0 | download_files | admin  | Редактировать Удалить Block   |
      |  2 | anna  | anna@gmail.com       | 23.00 руб. |       2 | download_files | user   | Редактировать Удалить Block   |
      |  3 | petr  | petr@gmail.com       | 43.00 руб. |       4 | download_files | user   | Редактировать Удалить Block   |
      |  4 | vlad  | vlad@gmail.com       | 43.00 руб. |       0 | download_files | user   | Редактировать Удалить Unblock |


  Сценарий: Просмотр учетной записи пользователя
    Допустим я на странице "admin_users"
    И перейду по ссылке "petr"
    То я увижу "petr"
    И увижу "petr@gmail.com"
    И увижу "43.00"

  Сценарий: Редактирование пользователя
    Допустим я на странице "admin_users"
    Если перейду по ссылке "edit_3"
    И введу в поле "user[login]" значение "ivan"
    И нажму "Сохранить данные"
    То я увижу "Пользователь был успешно обновлен."
    И увижу "ivan"

  Сценарий: Блокировка пользователя
    Допустим я на странице "admin_users"
    Если перейду по ссылке "block_3"
    И введу в поле "user[term_ban]" значение "3"
    И введу в поле "user[ban_reason]" значение "Жалуються пользователи"
    И нажму "Заблокировать пользователя"
    То я увижу "Пользователь заблокирован."

  @selenium
  Сценарий: Удаление пользователя
    Допустим я на странице "admin_users"
    Если перейду по ссылке "delete_3"
    То я увижу окно потдверждения с "Delete user?"
    И я увижу "Пользователь был успешно удален."

  @selenium
  Сценарий: Разблокировка пользователя
    Допустим я на странице "admin_users"
    Если перейду по ссылке "unblock_4"
    То я увижу окно потдверждения с "Unblock user?"
    И я увижу "Пользователь разблокирован."
