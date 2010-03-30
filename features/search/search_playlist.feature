# language: ru
Функционал: Поиск  плейлистам

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       | last_login_ip | id      | balance |
     | admin      | admin_user@gmail.com | secret   | true   | user, admin | 234.221.4.1   |  1      | 10      |
     | petr       | petr@gmail.com       | secret   | true   | user        | 234.221.4.2   |  2      | 20      |
     | anna       | anna@gmail.com       | secret   | true   | user        | 234.221.4.3   |  3      | 30      |
    И есть следующие плейлисты:
    | id | title                              | description       | user_email     | user_id |
    |  1 | Мой крутой альбом шансона          | Попсовая подборка | petr@gmail.com |       2 |
    |  2 | А это мой не самый крутой плейлист | Музыка шансон     | petr@gmail.com |       2 |
    |  3 | pop                                | Моя музыка        | anna@gmail.com |       3 |


    Допустим я на странице"the homepage"
    И я выберу "search-playlist"
Сценарий: Поиск плейлиста
  И я введу в поле "search_string" значение "А это мой не самый крутой плейлист"
  И я нажму "submit_search_form"
  То я увижу "А это мой не самый крутой плейлист"

Сценарий: Поиск плейлиста с нулевым запросом
  Допустим я введу в поле "search_string" значение ""
  И я нажму "submit_search_form"
  То я увижу "У вас пустой запрос"

Сценарий: Поиск плейлиста с нулевым результатом
  Допустим я введу в поле "search_string" значение "флыралдфыоварлфыра"
  И я нажму "submit_search_form"
  То я увижу "Поиск по плей листам с текущим запросом не дал результатов, уточните запрос"

