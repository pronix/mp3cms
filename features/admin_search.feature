# language: ru
Функционал: Поиск в административной панели
  Админи могут искать по новостям, мп3, пользователям, плейлистам, транзакциям

  Предыстория:
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       |
     | admin      | admin_user@gmail.com | secret   | true   | user, admin |
     | petr       | petr@gmail.com       | secret   | true   | user        |
     | anna       | anna@gmail.com       | secret   | true   | user        |
    И есть следующие плейлисты:
    | id | title                      | description         | user_email     |
    |  1 | Мой крутой альбом шансона                  | Попсовая подборка               | petr@gmail.com |
    |  2 | А это мой не самый крутой плейлист  | Музыка шансон                      | petr@gmail.com |
    |  3 | pop                        | Моя музыка                              | anna@gmail.com |
        И есть следующие треки:
       | id  | title                               | author          | bitrate | dimension | playlist | user_email     | state      |
       | 1   | Lucky                               | Jason marz      | 192     | 50000     | pop           | petr@gmail.com | active     |
       | 2   | Life Is Wonderful - Jason Mraz      | Jason marz      | 192     | 60000     | pop    | petr@gmail.com | active     |
       | 3   | Angel                               | Happy Mondays   | 128     | 70000     | Мой крутой альбом шансона   | petr@gmail.com | moderation |
       | 4   | Theme From Netto                    | Happy Mondays   | 320     | 50000     | Мой крутой альбом шансона      | petr@gmail.com | moderation |
       | 5   | Theme Is Wonderful_2 - Jason Mraz   | Jason marz      | 128     | 50000     | А это мой не самый крутой плейлист        | anna@gmail.com | banned     |
       | 6   | All Alone                           | Gorillaz        | 128     | 50000     | А это мой не самый крутой плейлист        | anna@gmail.com | banned     |


  И в сервисе есть следующие новости
  | id | header         | title    | meta                                                     | text            |
  | 1  | Сегодня сгорел дом  | Строим дом   | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
  | 2  | Завтра строим дом    | Строим          | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
  | 3  | Ракета молот             | Ракета молот| Ракета молот  Ракета молот  Ракета молот  Ракета молот  Ракета молот                | Ракета не воробей!     |
  Допустим я зашел в сервис как "admin_user@gmail.com/secret"

Сценарий: Поиск по новостям в админке с пустым запросом
  Допустим я на странице "поиск по новостям"
  И я запишу в поле "search" значение ""
  И я выберу "attribute_everywhere"
  И я нажму "Найти"
  То я увижу "У вас пустой запрос"

Сценарий: Поиск по новостям с нулевум результатом
  Допустим я на странице "поиск по новостям"
  И я запишу в поле "search" значение "kjahsdgfjkahsdgf"
  И я выберу "attribute_everywhere"
  И я нажму "Найти"
  То я увижу "Поиск по данному запросу не принёс результатов"

Сценарий: Поиск с атрибутом ВЕЗДЕ и перехрд по ссылки РЕДАКТИРОВАТЬ
  Допустим я на странице "поиск по новостям"
  И я запишу в поле "search" значение "Сегодня сгорел дом"
  И я выберу "attribute_everywhere"
  И я нажму "Найти"
  То я увижу "Сегодня сгорел дом"
  И я перейду по ссылке "Редактировать"

Сценарий: Поиск новости с атрибутом ПО ID и перехрд по ссылки удалить
  Допустим я на странице "поиск по новостям"
  И я запишу в поле "search" значение "2"
  И я выберу "attribute_id"
  И я нажму "Найти"
  То я увижу "Завтра строим дом"
  И я перейду по ссылке "Удалить"
  То я не увижу "Завтра строим дом"


#======== START_PLAYLISTS ====================

Сценарий: Поиск а админке плейлиста по id и его последующиму удалению
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "2"
  И я выберу "attribute_id"
  И я нажму "Найти"
  То я увижу "А это мой не самый крутой плейлист"
  И я перейду по ссылке "Удалить"
  То я не увижу "А это мой не самый крутой плейлист"
  И увижу "Плейлист был удалён"

Сценарий: Поиск а админке плейлиста по НАЗВАНИЮ и его последующиму редактированию
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "А это мой не самый крутой плейлист"
  И я выберу "attribute_title"
  И я нажму "Найти"
  То я увижу "А это мой не самый крутой плейлист"
  И я перейду по ссылке "Редактировать"

Сценарий: Поиск а админке плейлиста по ЛОГИНУ пользователя
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "petr"
  И я выберу "attribute_login"
  И я нажму "Найти"
  То я увижу "Мой крутой альбом шансона"

Сценарий: Поиск а админке плейлиста с нулевым запросом
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение ""
  И я выберу "attribute_login"
  И я нажму "Найти"
  То я увижу "У вас пустой запрос"

Сценарий: Поиск а админке плейлиста с нулевым результатом
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "флыралдфыоварлфыра"
  И я выберу "attribute_login"
  И я нажму "Найти"
  То я увижу "Записи отсутствуют, уточните критерий поиска"

#======== END_PLAYLISTS ====================
#======== START_PLAYLISTS ====================

Сценарий: Поиск а админке mp3 С нулевым запросом
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение ""
  И я выберу "attribute_bitrate"
  И я нажму "Найти"
  То я увижу "У вас пустой запрос"

Сценарий: Поиск а админке mp3 С нулевым результатом
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "ждфлывоаджфлывоаждфылвоаждфылвоа"
  И я выберу "attribute_bitrate"
  И я нажму "Найти"
  То я увижу "Записи отсутствуют, уточните критерий поиска"

Сценарий: Поиск а админке mp3 по ID и перехрд на редактирование трека
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "2"
  И я выберу "attribute_id"
  И я нажму "Найти"
  То я увижу "Life Is Wonderful - Jason Mraz"
  И я перейду по ссылке "Редактировать"

Сценарий: Поиск а админке mp3 по author и удаление трека
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "Gorillaz"
  И я выберу "attribute_author"
  И я нажму "Найти"
  То я увижу "All Alone"
  И я перейду по ссылке "Удалить"
  То я не увижу "All Alone"

Сценарий: Поиск а админке mp3 по title
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "Angel"
  И я выберу "attribute_title"
  И я нажму "Найти"
  То я увижу "Angel"

Сценарий: Поиск а админке mp3 по bitrate
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "320"
  И я выберу "attribute_bitrate"
  И я нажму "Найти"
  То я увижу "Theme From Netto"

Сценарий: Поиск а админке mp3 по весу меньше значения 60000
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "60000"
  И я выберу "attribute_less"
  И я нажму "Найти"
  То я увижу "Theme From Netto"
  И я увижу "Theme Is Wonderful_2 - Jason Mraz"
  И я увижу "All Alone"
  И я увижу "Lucky"

Сценарий: Поиск а админке mp3 по весу больше значения 60000
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "60000"
  И я выберу "attribute_more"
  И я нажму "Найти"
  То я увижу "Angel"

Сценарий: Поиск а админке mp3 по весу равно значению 70000
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "70000"
  И я выберу "attribute_well"
  И я нажму "Найти"
  То я увижу "Angel"

Сценарий: Поиск а админке mp3 по пользователю добавившему фаил
  Допустим я на странице "поиск по плейлистам"
  И я запишу в поле "search" значение "70000"
  И я выберу "attribute_user"
  И я нажму "Найти"
  То я увижу "Theme Is Wonderful_2 - Jason Mraz"
  И я увижу "All Alone"

#======== END_PLAYLISTS ====================

