# language: ru
Функционал: Плейлисты
Пользователь имеет 3 варианта поиска:
1. Поиск по mp3
2. Поиск по плейлистам
3. Поиск по сайту

При выборе мп3 добавляем дополнительные параметры поиска: По исполнителю, по названию, везде.
Title страницы результата поиска состоит из запроса пользователя. Все запросы хранятся определенное время в базе и выводятся на сайте как последние и популярные запросы.
Запросы храним в базе за последние 7 дней. На сайте выводим списом последних и популярных запросов - ссылки под текстом запросов ведут на результат поиска.

Предыстория:
  Допустим в проекте есть следующие плей листы
    | id  | title                     | description                             |
    | 1   | Мой крутой альбом шансона               | Тут собраны все самые понтовые треки нашего подезда |
    | 2   | А это мой не самый крутой плейлист| Тут тоже понтовые треки                                                       |
    | 3   | pop                       | pop, dance                              |

  И в проекте есть следующие треки
    | title                               | author         | bitrate | dimension | playlist_id |
    | Lucky                               | Jason marz     | 128     | 26000     | 1           |
    | Life Is Wonderful - Jason Mraz      | Jason marz     | 192     | 85000     | 1           |
    | Angel                               | Happy Mondays  | 128     | 98234     | 1           |
    | Theme From Netto                    | Happy Mondays  | 128     | 26000     | 2           |
    | Theme Is Wonderful_2 - Jason Mraz   | Jason marz     | 192     | 85000     | 2           |
    | All Alone                           | Gorillaz       | 128     | 98234     | 3           |
    | Intro                               | Gorillaz       | 128     | 26000     | 3           |

  И в проекте есть следующие новости
  | header         | title    | meta                                                     | content            |
  | Сегодня сгорел дом  | Строим дом   | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
  | Завтра строим дом    | Строим          | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
  | Ракета молот             | Ракета молот| Ракета молот  Ракета молот  Ракета молот  Ракета молот  Ракета молот                | Ракета не воробей!     |

  И в проекте есть следующие прошедшие запросы
  | request           | attributes |
  | Скачать мп3         | Everywhere |
  | Happy Mondays     | author     |
  | Life Is Wonderful | title      |


Сценарий: Поиск mp3 с параметром "везде"
  И я на странице "search"
  Допустим я в поле "search" пишу "Jason marz"
  И я выбираю "Поиск везде"
  И нажимаю "Найти"

  То я должен видить "Life Is Wonderful - Jason Mraz"
  И я должен видить "Lucky"
  И я должен видить "Theme Is Wonderful_2 - Jason Mraz"
  И я не должен видить "Happy Mondays"
  И я не должен видить "Gorillaz"

Сценарий: Поиск mp3 с параметром "по названию"
  И я на странице "search"
  Допустим я в поле "search" пишу "Theme"
  И я выбираю "По названию"
  И нажимаю "Найти"

  То я должен видить "Theme Is Wonderful_2 - Jason Mraz"
  И я должен видить "Theme From Netto"

Сценарий: Поиск mp3 с параметром "По исполнителю"
  И я на странице "search"
  Допустим я в поле "search" пишу "Happy Mondays"
  И я выбираю "По исполнителю"
  И нажимаю "Найти"
  То я должен видить "Angel"
  И я должен видить "Theme From Netto"


Сценарий: Поиск по плейлистам
  И я на странице "search"
  Допустим я перехожу "Поиск плейлистов"
  И в поле "search" пишу "Мой"
  И нажимаю "Найти"
  То я должен видить "Мой крутой альбом шансона"
  И я должен видить "А это мой не самый крутой плейлист"
  И я не должен видить "pop"

Сценарий: Последние запросы поиска
  Допустим я на странице "/"
  То я должен видить "Скачать мп3"
  И я должен видить "Happy Mondays"
  И я должен видить "Life Is Wonderful"
  И я перехожу "Life Is Wonderful"

Сценарий: Поиск по новостям
  Допустим я на странице поиска новостей
  И в поле "search" пишу "дом"
  И нажимаю "Найти"
  То я должен увидить "Завтра строим дом"
  И я должен увидить "Сегодня сгорел дом"
  И я не должен увидить "Ракета молот"
  И если я перехожу "Завтра строим дом"
  То я должен увидить "Завтра строим дом"

