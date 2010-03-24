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
    | id | title                      | description         | user_email     | user_id |
    |  1 | Мой крутой альбом шансона                  | Попсовая подборка               | petr@gmail.com |  2      |
    |  2 | А это мой не самый крутой плейлист  | Музыка шансон                      | petr@gmail.com |  2      |
    |  3 | pop                        | Моя музыка                              | anna@gmail.com |  3      |

    И я на странице "the homepage"
Сценарий: Поиск плейлиста
  И я введу в поле "search_playlist" значение "А это мой не самый крутой плейлист"
  И я нажму "Найти" в "#search_playlist"
  То я увижу "А это мой не самый крутой плейлист"

Сценарий: Поиск а админке плейлиста с нулевым запросом
  И я введу в поле "search_playlist" значение ""
  И я нажму "Найти" в "#search_playlist"
  То я увижу "По вашему запросу ничего не найденно"

Сценарий: Поиск а админке плейлиста с нулевым результатом
  И я введу в поле "search_playlist" значение "флыралдфыоварлфыра"
  И я нажму "Найти" в "#search_playlist"
  То я увижу "По вашему запросу ничего не найденно"

