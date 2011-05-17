# language: ru

@no-txn @green
Функционал: Поиск в административной панели по трекам
Поиск по исполнителю, названию, айди, битрейту, весу файла (больше, меньше или равно), по пользователю добавившему файл.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(admin:true), user, moderator"
    И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       | last_login_ip | id | balance |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |   234.221.4.1 |  1 |      10 |
     | petr  | petr@gmail.com       | secret   | true   | user        |   234.221.4.2 |  2 |      20 |
     | anna  | anna@gmail.com       | secret   | true   | user        |   234.221.4.3 |  3 |      30 |
    И есть следующие плейлисты:
     | id | title | description       | user_email     | user_id |
     |  1 | sh    | Попсовая подборка | petr@gmail.com |       2 |
     |  2 | cool  | Музыка шансон     | petr@gmail.com |       2 |
     |  3 | pop   | Моя музыка        | anna@gmail.com |       3 |
    И загружены следующие треки:
     | id | title                | author        | bitrate | data_file_size | playlist | user_email     | state      | user_id |
     |  2 | Life Is l - J Mraz   | Jason marz    |     192 |          60000 | pop      | petr@gmail.com | active     |       2 |
     |  1 | Lucky                | Jason marz    |     192 |          50000 | pop      | petr@gmail.com | active     |       2 |
     |  3 | Angel                | Happy Mondays |     128 |          70000 | sh       | petr@gmail.com | active     |       2 |
     |  4 | Theme From Netto     | Happy Mondays |     320 |          50000 | sh       | petr@gmail.com | active     |       2 |
     |  5 | Theme Is _2 - J Mraz | Jason marz    |     128 |          50000 | cool     | anna@gmail.com | banned     |       3 |
     |  6 | All Alone            | Gorillaz      |     128 |          50000 | cool     | anna@gmail.com | banned     |       3 |
     |  7 | All Alone_2          | Gorillaz      |     128 |          50000 | cool     | anna@gmail.com | moderation |       3 |
    И обновляем индексы Sphinx
    И я зашел в сервис как "admin_user@gmail.com/secret"
    И я на странице "поиск в админке"

  Сценарий: Мы на главной странице поиска и тестируем выдачу треков на модерацию
    Допустим я увижу "All Alone_2"

  Сценарий: Поиск а админке mp3 С нулевым запросом, нулевым результатом
    Допустим я введу в поле "q" значение ""
    И я выберу "attribute_bitrate" в "#form_track"
    И я нажму "search_track" в "#form_track"
    То я увижу "У вас пустой запрос"
    Допустим я введу в поле "q" значение "ждфлывоаджфлывоаждфылвоаждфылвоа"
    Допустим я выберу "attribute_bitrate" в "#form_track"
    И я нажму "search_track" в "#form_track"
    То я увижу "По вашему запросу ничего не найденно"

  Сценарий: Поиск а админке mp3 по ID, author, title, bitrate
    Допустим я введу в поле "q" значение "2" в селекторе "#form_track"
    И я выберу "attribute_id" в "#form_track"
    И я нажму "search_track" в "#form_track"
    То я увижу "Life Is l - J Mraz"
    Допустим я введу в поле "q" значение "Gorillaz" в селекторе "#form_track"
    И я выберу "attribute_author" в "#form_track"
    И я нажму "search_track" в "#form_track"
    То я увижу "All Alone"
    Допустим я введу в поле "q" значение "Angel" в селекторе "#form_track"
    И я выберу "attribute_title" в "#form_track"
    И я нажму "search_track" в "#form_track"
    То я увижу "Angel"
    Допустим я введу в поле "q" значение "320" в селекторе "#form_track"
    И я выберу "attribute_bitrate" в "#form_track"
    И я нажму "search_track" в "#form_track"
    То я увижу "Theme From Netto"

  Сценарий: Поиск а админке mp3 по весу равно значению 870400
    Допустим я введу в поле "q" значение "870400" в селекторе "#form_track"
    И я выберу "attribute_well" в "#form_track"
    И я выберу "state_all"
    И я нажму "search_track" в "#form_track"
    То я увижу "Angel"

  Сценарий: Поиск а админке mp3 по пользователю добавившему фаил
    Допустим я введу в поле "q" значение "petr" в селекторе "#form_track"
    И я выберу "attribute_login" в "#form_track"
    И я нажму "search_track" в "#form_track"
    То я увижу "Lucky"
    И я увижу "Life Is l - J Mraz"
    И я увижу "Angel"
    И я увижу "Theme From Netto"
