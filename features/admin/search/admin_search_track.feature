# language: ru
Функционал: Поиск в административной панели по трекам
Поиск по исполнителю, названию, айди, битрейту, весу файла (больше, меньше или равно), по пользователю добавившему файл.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
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


#    И загружены следующие треки:
#| id | title              | author       | playlist | user_email     | state  | count_downloads |
#| 2 | Городские встречи  | С. Наговицын | Шансон   | petr@gmail.com | active |             78  |
#| 1 | Девочка-проказница | С. Наговицын | Шансон   | petr@gmail.com | active |             63  |
#| 3 | Wind of change     | Scorpions    | Разное   | anna@gmail.com | active |             25  |
#| 4 | Send Me An Angel   | Scorpions    | Разное   | anna@gmail.com | active |             13  |
#| 5 | Музыка нас связала | Мираж        | Разное   | anna@gmail.com | active |              0  |

    И загружены следующие треки:
| id | title                             | author        | bitrate | data_file_size | playlist                           | user_email     | state      | user_id |
|  2 | Life Is Wonderful - Jason Mraz    | Jason marz    |     192 |          60000 | pop                                | petr@gmail.com | active     |       2 |
|  1 | Lucky                             | Jason marz    |     192 |          50000 | pop                                | petr@gmail.com | active     |       2 |
|  3 | Angel                             | Happy Mondays |     128 |          70000 | Мой крутой альбом шансона          | petr@gmail.com | active     |       2 |
|  4 | Theme From Netto                  | Happy Mondays |     320 |          50000 | Мой крутой альбом шансона          | petr@gmail.com | active     |       2 |
|  5 | Theme Is Wonderful_2 - Jason Mraz | Jason marz    |     128 |          50000 | А это мой не самый крутой плейлист | anna@gmail.com | banned     |       3 |
|  6 | All Alone                         | Gorillaz      |     128 |          50000 | А это мой не самый крутой плейлист | anna@gmail.com | banned     |       3 |
|  7 | All Alone_2                       | Gorillaz      |     128 |          50000 | А это мой не самый крутой плейлист | anna@gmail.com | moderation |       3 |


  И обновляем индексы Sphinx
  И я зашел в сервис как "admin_user@gmail.com/secret"
  И я на странице "поиск в админке"

Сценарий: Мы на главной странице поиска и тестируем выдачу треков на модерацию
  Допустим я увижу "All Alone_2"

Сценарий: Поиск а админке mp3 С нулевым запросом
  Допустим я введу в поле "q" значение ""
  И я выберу "attribute_bitrate" в "#form_track"
  И я нажму "search_track" в "#form_track"
  То я увижу "У вас пустой запрос"

Сценарий: Поиск а админке mp3 С нулевым результатом
  Допустим я введу в поле "q" значение "ждфлывоаджфлывоаждфылвоаждфылвоа"
  Допустим я выберу "attribute_bitrate" в "#form_track"
  И я нажму "search_track" в "#form_track"
  То я увижу "По вашему запросу ничего не найденно"

Сценарий: Поиск а админке mp3 по ID
  Допустим я введу в поле "q" значение "2" в селекторе "#form_track"
  И я выберу "attribute_id" в "#form_track"
  И я нажму "search_track" в "#form_track"
  То я увижу "Life Is Wonderful - Jason Mraz"


Сценарий: Поиск а админке mp3 по author
  Допустим я введу в поле "q" значение "Gorillaz" в селекторе "#form_track"
  И я выберу "attribute_author" в "#form_track"
  И я нажму "search_track" в "#form_track"
  То я увижу "All Alone"

Сценарий: Поиск а админке mp3 по title
  Допустим я введу в поле "q" значение "Angel" в селекторе "#form_track"
  И я выберу "attribute_title" в "#form_track"
  И я нажму "search_track" в "#form_track"
  То я увижу "Angel"

Сценарий: Поиск а админке mp3 по bitrate
  Допустим я введу в поле "q" значение "320" в селекторе "#form_track"
  И я выберу "attribute_bitrate" в "#form_track"
  И я нажму "search_track" в "#form_track"
  То я увижу "Theme From Netto"

#Сценарий: Поиск а админке mp3 по весу меньше значения 60000
#  Допустим я введу в поле "q" значение "60000" в селекторе "#form_track"
#  И я выберу "attribute_less" в "#form_track"
#  И я выберу "state_all"
#  И я нажму "search_track" в "#form_track"
#  То я увижу "Theme From Netto"
#  И я увижу "Theme Is Wonderful_2 - Jason Mraz"
#  И я увижу "All Alone"
#  И я увижу "Lucky"

#Сценарий: Поиск а админке mp3 по весу больше значения 60000
#  Допустим я введу в поле "q" значение "60000" в селекторе "#form_track"
#  И я выберу "attribute_more" в "#form_track"
#  И я выберу "state_all"
#  И я нажму "search_track" в "#form_track"
#  То я увижу "Angel"

#Сценарий: Поиск а админке mp3 по весу больше значения 40000 и на модерации
#  Допустим я введу в поле "q" значение "40000" в селекторе "#form_track"
#  И я выберу "attribute_more" в "#form_track"
#  И я выберу "state_moderation"
#  И я нажму "search_track" в "#form_track"
#  То я увижу "All Alone_2"

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
  И я увижу "Life Is Wonderful - Jason Mraz"
  И я увижу "Angel"
  И я увижу "Theme From Netto"
