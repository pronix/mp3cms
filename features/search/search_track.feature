# language: ru
Функционал: Поиск в на портале
Поиск по исполнителю, названию, везде

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

    И загружены следующие треки:
| id | title                             | author        | bitrate | data_file_size | playlist                           | user_email     | state      | user_id |
|  1 | Lucky                             | Jason marz    |     192 |          50000 | pop                                | petr@gmail.com | active     |       2 |
|  2 | Life Is Wonderful - Jason Mraz    | Jason marz    |     192 |          60000 | pop                                | petr@gmail.com | active     |       2 |
|  3 | Angel                             | Happy Mondays |     128 |          70000 | Мой крутой альбом шансона          | petr@gmail.com | active     |       2 |
|  4 | Theme From Netto                  | Happy Mondays |     320 |          50000 | Мой крутой альбом шансона          | petr@gmail.com | active     |       2 |
|  5 | Theme Is Wonderful_2 - Jason Mraz | Jason marz    |     128 |          50000 | А это мой не самый крутой плейлист | anna@gmail.com | banned     |       3 |
|  6 | All Alone                         | Gorillaz      |     128 |          50000 | А это мой не самый крутой плейлист | anna@gmail.com | active     |       3 |
|  7 | All Alone_2                       | Gorillaz      |     128 |          50000 | А это мой не самый крутой плейлист | anna@gmail.com | moderation |       3 |

  И обновляем индексы Sphinx
  И я на странице "the homepage"

Сценарий: Поиск треков с нулевым запросом
  Допустим я введу в поле "search_string" значение ""
  И я установлю галку в "everywhere"
  И я нажму "submit_search_form"
  То я увижу "У вас пустой запрос"

Сценарий: Поиск треков нулевым результатом
  Допустим я введу в поле "search_string" значение "ждфлывоаджфлывоаждфылвоаждфылвоа"
  И я установлю галку в "everywhere"
  И я нажму "submit_search_form"
  То я увижу "Файл ждфлывоаджфлывоаждфылвоаждфылвоа не найден в нашей базе, попробуйте запросить его в столе заказов"

Сценарий: Поиск mp3 по author
  Допустим я введу в поле "search_string" значение "Gorillaz"
  И я установлю галку в "author"
  И я нажму "submit_search_form"
  То я увижу "All Alone"

Сценарий: Поиск mp3 по title
  Допустим я введу в поле "search_string" значение "Angel"
  И я установлю галку в "title"
  И я нажму "submit_search_form"
  То я увижу "Angel"

Сценарий: Поиск mp3 по author
  И обновляем индексы Sphinx
  Допустим я введу в поле "search_string" значение "Gorillaz"
  И я установлю галку в "author"
  И я нажму "submit_search_form"
  То я увижу "All Alone"
  И я не увижу "All Alone_2"

