 language: ru
Функционал: Поиск в административной панели по пользователям
Поиск по логину, мылу, кошельку, айпи, айди.

  Предыстория:
   Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       | last_login_ip | current_login_ip | id      | balance |
     | admin      | admin_user@gmail.com | secret   | true   | user, admin | 234.221.4.1   | 234.221.4.1      | 1      | 10      |
     | petr       | petr@gmail.com       | secret   | true   | user        | 234.221.4.2   | 234.221.4.2      | 2      | 20      |
     | anna       | anna@gmail.com       | secret   | true   | user        | 234.221.4.3   | 234.221.4.2      | 3      | 30      |
    И есть следующие плейлисты:
    | id | title                      | description         | user_email     | user_id |
    |  1 | Мой крутой альбом шансона                  | Попсовая подборка               | petr@gmail.com |  2      |
    |  2 | А это мой не самый крутой плейлист  | Музыка шансон                      | petr@gmail.com |  2      |
    |  3 | pop                        | Моя музыка                              | anna@gmail.com |  3      |
    И загружены следующие треки:
| id  | title                               | author          | bitrate | dimension | playlist                   | user_email     | state      |user_id|
| 1   | Lucky                               | Jason marz      | 192     | 50000     | pop                        | petr@gmail.com | active     | 2 |
| 2   | Life Is Wonderful - Jason Mraz      | Jason marz      | 192     | 60000     | pop                        | petr@gmail.com | active     |2 |
| 3   | Angel                               | Happy Mondays   | 128     | 70000     | Мой крутой альбом шансона                 | petr@gmail.com | moderation |2 |
| 4   | Theme From Netto                    | Happy Mondays   | 320     | 50000     | Мой крутой альбом шансона                 | petr@gmail.com | moderation |2 |
| 5   | Theme Is Wonderful_2 - Jason Mraz   | Jason marz      | 128     | 50000     | А это мой не самый крутой плейлист  | anna@gmail.com | banned     |3 |
| 6   | All Alone                           | Gorillaz        | 128     | 50000     | А это мой не самый крутой плейлист  | anna@gmail.com | banned     |3 |


#  И в сервисе есть следующие новости
#  | id | header         | title    | meta                                                     | text            |
#  | 1  | Сегодня сгорел дом  | Строим дом   | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
#  | 2  | Завтра строим дом    | Строим          | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
#  | 3  | Ракета молот             | Ракета молот| Ракета молот  Ракета молот  Ракета молот  Ракета молот  Ракета молот                | Ракета не воробей!     |

  И я зашел в сервис как "admin_user@gmail.com/secret"
  И обновляем индексы Sphinx
  И я на странице "поиск в админке"

Сценарий: Поиск а админке пользователей по логину
  И я введу в поле "search_user" значение "petr"
  И я выберу "attribute_login" в "#form_user"
  И я нажму "Найти" в "#form_user"
  То я увижу "petr"


Сценарий: Поиск а админке пользователей по email
  И я введу в поле "search_user" значение "petr@gmail.com"
  И я выберу "attribute_email" в "#form_user"
  И я нажму "Найти" в "#form_user"
  То я увижу "petr"

Сценарий: Поиск а админке пользователей с нулевым запросом в поле
  И я введу в поле "search_user" значение ""
  И я нажму "Найти" в "#form_user"
  То я увижу "По вашему запросу ничего не найденно"

Сценарий: Поиск а админке пользователей с нулевым ответом
  И я введу в поле "search_user" значение "фоыврафлоыварлфыова"
  И я нажму "Найти"
  То я увижу "По вашему запросу ничего не найденно"

Сценарий: Поиск а админке пользователей по id
  И я введу в поле "search_user" значение "2"
  И я выберу "attribute_id" в "#form_user"
  И я нажму "Найти" в "#form_user"
  То я увижу "petr"

Сценарий: Поиск в админке пользователей по ip
  И я введу в поле "search_user" значение "234.221.4.2"
  И я выберу "attribute_ip" в "#form_user"
  И я нажму "Найти" в "#form_user"
  То я увижу "petr"
  И я увижу "anna"
  И я не увижу "admin"

#Сценарий: Поиск а админке пользователя по кошельку
#  И я введу в поле "search_user" значение "Кошилёк"
#  И я выберу "Кошелёк"
#  И я нажму "Найти"
#  То я увижу "petr"

Сценарий: Поиск а админке пользователей с нулевым ответом
  И я введу в поле "search_user" значение "фоыврафлоыварлфыова"
  И я нажму "Найти" в "#form_user"
  То я увижу "По вашему запросу ничего не найденно"

