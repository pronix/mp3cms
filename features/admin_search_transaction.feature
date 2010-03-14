# language: ru
Функционал: Поиск в административной панели
  Админи могут искать по новостям, мп3, пользователям, плейлистам, транзакциям

  Предыстория:
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
        И есть следующие треки:
| id  | title                               | author          | bitrate | dimension | playlist                   | user_email     | state      |user_id|
| 1   | Lucky                               | Jason marz      | 192     | 50000     | pop                        | petr@gmail.com | active     | 2 |
| 2   | Life Is Wonderful - Jason Mraz      | Jason marz      | 192     | 60000     | pop                        | petr@gmail.com | active     |2 |
| 3   | Angel                               | Happy Mondays   | 128     | 70000     | Мой крутой альбом шансона                 | petr@gmail.com | moderation |2 |
| 4   | Theme From Netto                    | Happy Mondays   | 320     | 50000     | Мой крутой альбом шансона                 | petr@gmail.com | moderation |2 |
| 5   | Theme Is Wonderful_2 - Jason Mraz   | Jason marz      | 128     | 50000     | А это мой не самый крутой плейлист  | anna@gmail.com | banned     |3 |
| 6   | All Alone                           | Gorillaz        | 128     | 50000     | А это мой не самый крутой плейлист  | anna@gmail.com | banned     |3 |


  И в сервисе есть следующие новости
  | id | header         | title    | meta                                                     | text            |
  | 1  | Сегодня сгорел дом  | Строим дом   | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
  | 2  | Завтра строим дом    | Строим          | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
  | 3  | Ракета молот             | Ракета молот| Ракета молот  Ракета молот  Ракета молот  Ракета молот  Ракета молот                | Ракета не воробей!     |
  Допустим я зашел в сервис как "admin_user@gmail.com/secret"

Сценирий: Поиск транзакция по дате
  Допустим я на странице "поиск по транзакциям"

