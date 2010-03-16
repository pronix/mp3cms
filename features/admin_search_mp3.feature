# language: ru
Функционал: Поиск в административной панели
  Админи могут искать по новостям, мп3, пользователям, плейлистам, транзакциям

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

    И загружены следующие треки:
| id  | title                               | author          | bitrate | dimension | playlist                   | user_email     | state      |user_id|
| 1   | Lucky                               | Jason marz      | 192     | 50000     | pop                        | petr@gmail.com | active     | 2 |
| 2   | Life Is Wonderful - Jason Mraz      | Jason marz      | 192     | 60000     | pop                        | petr@gmail.com | active     |2 |
| 3   | Angel                               | Happy Mondays   | 128     | 70000     | Мой крутой альбом шансона                 | petr@gmail.com | active     |2 |
| 4   | Theme From Netto                    | Happy Mondays   | 320     | 50000     | Мой крутой альбом шансона                 | petr@gmail.com | active     |2 |
| 5   | Theme Is Wonderful_2 - Jason Mraz   | Jason marz      | 128     | 50000     | А это мой не самый крутой плейлист  | anna@gmail.com | banned     |3 |
| 6   | All Alone                           | Gorillaz        | 128     | 50000     | А это мой не самый крутой плейлист  | anna@gmail.com | banned     |3 |

  Допустим я зашел в сервис как "admin_user@gmail.com/secret"

Сценарий: Поиск а админке mp3 С нулевым запросом
  Допустим я на странице "поиск по mp3"
  И я введу в поле "search_string" значение ""
  И я выберу "attribute_bitrate"
  И я нажму "Найти"
  То я увижу "У вас пустой запрос"

Сценарий: Поиск а админке mp3 С нулевым результатом
  Допустим я на странице "поиск по mp3"
  И я введу в поле "search_string" значение "ждфлывоаджфлывоаждфылвоаждфылвоа"
  И я выберу "attribute_bitrate"
  И я нажму "Найти"
  То я увижу "mp3 с таким bitrate не найденны"

Сценарий: Поиск а админке mp3 по ID и перехрд на редактирование трека
  Допустим я на странице "поиск по mp3"
  И я введу в поле "search_string" значение "2"
  И я выберу "attribute_id"
  И я нажму "Найти"
  То я увижу "Life Is Wonderful - Jason Mraz"
  И я перейду по ссылке "Редактировать"

Сценарий: Поиск а админке mp3 по author и удаление трека
  Допустим я на странице "поиск по mp3"
  И я введу в поле "search_string" значение "Gorillaz"
  И я выберу "attribute_author"
  И я нажму "Найти"
  То я увижу "All Alone"
  И я перейду по ссылке "Удалить"
  То я не увижу "All Alone"

Сценарий: Поиск а админке mp3 по title
  Допустим я на странице "поиск по mp3"
  И я введу в поле "search_string" значение "Angel"
  И я выберу "attribute_title"
  И я нажму "Найти"
  То я увижу "Angel"

Сценарий: Поиск а админке mp3 по bitrate
  Допустим я на странице "поиск по mp3"
  И я введу в поле "search_string" значение "320"
  И я выберу "attribute_bitrate"
  И я нажму "Найти"
  То я увижу "Theme From Netto"

Сценарий: Поиск а админке mp3 по весу меньше значения 60000
  Допустим я на странице "поиск по mp3"
  И я введу в поле "search_string" значение "60000"
  И я выберу "attribute_less"
  И я нажму "Найти"
  То я увижу "Theme From Netto"
  И я увижу "Theme Is Wonderful_2 - Jason Mraz"
  И я увижу "All Alone"
  И я увижу "Lucky"

Сценарий: Поиск а админке mp3 по весу больше значения 60000
  Допустим я на странице "поиск по mp3"
  И я введу в поле "search_string" значение "60000"
  И я выберу "attribute_more"
  И я нажму "Найти"
  То я увижу "Angel"

Сценарий: Поиск а админке mp3 по весу равно значению 70000
  Допустим я на странице "поиск по mp3"
  И я введу в поле "search_string" значение "70000"
  И я выберу "attribute_well"
  И я нажму "Найти"
  То я увижу "Angel"

Сценарий: Поиск а админке mp3 по пользователю добавившему фаил
  Допустим я на странице "поиск по mp3"
  И я введу в поле "search_string" значение "petr"
  И я выберу "attribute_login"
  И я нажму "Найти"
  То я увижу "Lucky"
  И я увижу "Life Is Wonderful - Jason Mraz"
  И я увижу "Angel"
  И я увижу "Theme From Netto"

