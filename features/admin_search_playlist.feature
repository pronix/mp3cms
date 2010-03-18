# language: ru
Функционал: Поиск в административной панели по плейлистам
По айди, по логину пользователя, по названию.

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
#
#    И загружены следующие треки:
#          | title              | author       | playlist | user_email     | state      |
#          | Музыка нас связала | Мираж        | Попса    | petr@gmail.com | active     |
#          | Наше время пришло  | Комиссар     | Попса    | petr@gmail.com | active     |
#          | Городские встречи  | С. Наговицын | Шансон   | petr@gmail.com | moderation |
#          | Девочка-проказница | С. Наговицын | Шансон   | petr@gmail.com | moderation |
#          | Wind of change     | Scorpions    | Разное   | anna@gmail.com | banned     |
#          | Send Me An Angel   | Scorpions    | Разное   | anna@gmail.com | banned     |

    И загружены следующие треки:
| id  | title                               | author          | bitrate | dimension | playlist                   | user_email     | state      |user_id|
| 1   | Lucky                               | Jason marz      | 192     | 50000     | pop                        | petr@gmail.com | active     | 2 |
| 2   | Life Is Wonderful - Jason Mraz      | Jason marz      | 192     | 60000     | pop                        | petr@gmail.com | active     |2 |
| 3   | Angel                               | Happy Mondays   | 128     | 70000     | Мой крутой альбом шансона                 | petr@gmail.com | moderation |2 |
| 4   | Theme From Netto                    | Happy Mondays   | 320     | 50000     | Мой крутой альбом шансона                 | petr@gmail.com | moderation |2 |
| 5   | Theme Is Wonderful_2 - Jason Mraz   | Jason marz      | 128     | 50000     | А это мой не самый крутой плейлист  | anna@gmail.com | banned     |3 |
| 6   | All Alone                           | Gorillaz        | 128     | 50000     | А это мой не самый крутой плейлист  | anna@gmail.com | banned     |3 |


  Допустим я зашел в сервис как "admin_user@gmail.com/secret"

Сценарий: Поиск а админке плейлиста по id
  Допустим я на странице "поиск по плейлистам"
  И я введу в поле "search_string" значение "2"
  И я выберу "attribute_id"
  И я нажму "Найти"
  То я увижу "А это мой не самый крутой плейлист"

Сценарий: Поиск а админке плейлиста по НАЗВАНИЮ
  Допустим я на странице "поиск по плейлистам"
  И я введу в поле "search_string" значение "А это мой не самый крутой плейлист"
  И я выберу "attribute_title"
  И я нажму "Найти"
  То я увижу "А это мой не самый крутой плейлист"

Сценарий: Поиск а админке плейлиста по ЛОГИНУ пользователя
  Допустим я на странице "поиск по плейлистам"
  И я введу в поле "search_string" значение "petr"
  И я выберу "attribute_login"
  И я нажму "Найти"
  То я увижу "Мой крутой альбом шансона"

  Если я введу в поле "search_string" значение "lajdshfakhf"
  И я выберу "attribute_login"
  И я нажму "Найти"
  То я увижу "Пользователь с таким логином не найден"

Сценарий: Поиск а админке плейлиста с нулевым запросом
  Допустим я на странице "поиск по плейлистам"
  И я введу в поле "search_string" значение ""
  И я выберу "attribute_login"
  И я нажму "Найти"
  То я увижу "У вас пустой запрос"

Сценарий: Поиск а админке плейлиста с нулевым результатом
  Допустим я на странице "поиск по плейлистам"
  И я введу в поле "search_string" значение "флыралдфыоварлфыра"
  И я выберу "attribute_login"
  И я нажму "Найти"
  То я увижу "Пользователь с таким логином не найден"

