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
  Допустим в сервисе есть следующие плей листы
    | id  | title                     | description                             |
    | 1   | Мой крутой альбом шансона               | Тут собраны все самые понтовые треки нашего подезда |
    | 2   | А это мой не самый крутой плейлист| Тут тоже понтовые треки                                                       |
    | 3   | pop                       | pop, dance                              |

  И в сервисе есть следующие треки
    | title                               | author         | bitrate | dimension | playlist_id |
    | Lucky                               | Jason marz     | 128     | 26000     | 1           |
    | Life Is Wonderful - Jason Mraz      | Jason marz     | 192     | 85000     | 1           |
    | Angel                               | Happy Mondays  | 128     | 98234     | 1           |
    | Theme From Netto                    | Happy Mondays  | 128     | 26000     | 2           |
    | Theme Is Wonderful_2 - Jason Mraz   | Jason marz     | 192     | 85000     | 2           |
    | All Alone                           | Gorillaz       | 128     | 98234     | 3           |
    | Intro                               | Gorillaz       | 128     | 26000     | 3           |

  И в сервисе есть следующие новости
  | header         | title    | meta                                                     | content            |
  | Сегодня сгорел дом  | Строим дом   | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
  | Завтра строим дом    | Строим          | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
  | Ракета молот             | Ракета молот| Ракета молот  Ракета молот  Ракета молот  Ракета молот  Ракета молот                | Ракета не воробей!     |

  И в сервисе есть следующие прошедшие запросы
  | search_string           | site_attributes | site_section |
  | Jason marz              | author          | mp3          |
  | Theme                   | title           | mp3          |
  | Life Is Wonderful       | everywhere      | mp3          |


Сценарий: Поиск mp3 с параметром "везде"
  Допустим обновляем индексы Sphinx
  И я на странице "the homepage"
  И я введу в поле "search_mp3" значение "Jason marz"
  И я выберу "attribute_everywhere"
  И я нажму "Найти" в "#mp3"

  То я увижу "Jason Mraz"
  И я увижу "Lucky"
  И я увижу "Theme Is Wonderful_2 - Jason Mraz"
  И я не увижу "Happy Mondays"
  И я не увижу "Gorillaz"

Сценарий: Поиск mp3 с параметром "по названию"
  Допустим обновляем индексы Sphinx
  И я на странице "the homepage"
  Допустим я введу в поле "search_mp3" значение "Theme"
  И я выберу "attribute_title"
  И я нажму "Найти" в "#mp3"
  То я увижу "Theme From Netto"

Сценарий: Поиск mp3 с параметром "По исполнителю"
  Допустим обновляем индексы Sphinx
  И я на странице "the homepage"
  Допустим я введу в поле "search_mp3" значение "Happy Mondays"
  И я выберу "attribute_author"
  И я нажму "Найти" в "#mp3"
  То я увижу "Angel"
  И я увижу "Theme From Netto"


Сценарий: Поиск по плейлистам
  Допустим обновляем индексы Sphinx
  И я на странице "the homepage"
  И я введу в поле "search_playlist" значение "Мой"
  И нажму "Найти" в "#playlist"
  То я увижу "Мой крутой альбом шансона"
  И я увижу "А это мой не самый крутой плейлист"
  И я не увижу "pop"

Сценарий: Последние запросы поиска
  Допустим я на странице "the homepage"
  То я увижу "Скачать мп3"
  И я  увижу "Happy Mondays"
  И я увижу "Life Is Wonderful"
  И я перехожу "Life Is Wonderful"

Сценарий: Поиск по новостям
  Допустим обновляем индексы Sphinx
  И я на странице "the homepage"
  И в введу в поле "search_news" значение "дом"
  И нажму "Найти" в "#news"
  То я увижу "Завтра строим дом"
  И я увижу "Сегодня сгорел дом"
  И я не увижу "Ракета молот"
  И я перейду "Завтра строим дом"
  То я увижу "Завтра строим дом"

