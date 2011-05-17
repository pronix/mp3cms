# language: ru

@no-txn @green
Функционал: Поиск в административной панели по плейлистам
По айди, по логину пользователя, по названию.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(admin:true), user, moderator"
    И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       | last_login_ip | id | balance |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |   234.221.4.1 |  1 |      10 |
     | petr  | petr@gmail.com       | secret   | true   | user        |   234.221.4.2 |  2 |      20 |
     | anna  | anna@gmail.com       | secret   | true   | user        |   234.221.4.3 |  3 |      30 |
    И есть следующие плейлисты:
     | id | title                              | description       | user_email     | user_id |
     |  1 | Мой крутой альбом шансона          | Попсовая подборка | petr@gmail.com |       2 |
     |  2 | А это мой не самый крутой плейлист | Музыка шансон     | petr@gmail.com |       2 |
     |  3 | pop                                | Моя музыка        | anna@gmail.com |       3 |
    И я зашел в сервис как "admin_user@gmail.com/secret"
    И я на странице "поиск плейлистов в админке"

  Сценарий: Поиск а админке плейлиста по id, Названию, Логину
    Если я введу в поле "q" значение "2" в селекторе "#form_playlist"
    И я выберу "attribute_id" в "#form_playlist"
    И я нажму "search_playlist" в "#form_playlist"
    То я увижу "А это мой не самый крутой плейлист"
    Если я введу в поле "q" значение "А это мой не самый крутой плейлист" в селекторе "#form_playlist"
    И я выберу "attribute_title"
    И я нажму "search_playlist" в "#form_playlist"
    То я увижу "А это мой не самый крутой плейлист"
    Если я введу в поле "q" значение "petr" в селекторе "#form_playlist"
    И я выберу "attribute_login" в "#form_playlist"
    И я нажму "search_playlist" в "#form_playlist"
    То я увижу "Мой крутой альбом шансона"
    Если я введу в поле "q" значение "lajdshfakhf" в селекторе "#form_playlist"
    И я выберу "attribute_login" в "#form_playlist"
    И я нажму "search_playlist" в "#form_playlist"
    То я увижу "По вашему запросу ничего не найденно"
    Если я введу в поле "q" значение "" в селекторе "#form_playlist"
    И я выберу "attribute_login" в "#form_playlist"
    И я нажму "search_playlist" в "#form_playlist"
    То я увижу "По вашему запросу ничего не найденно"
    Если я введу в поле "q" значение "флыралдфыоварлфыра" в селекторе "#form_playlist"
    И я выберу "attribute_login" в "#form_playlist"
    И я нажму "search_playlist" в "#form_playlist"
    То я увижу "По вашему запросу ничего не найденно"

