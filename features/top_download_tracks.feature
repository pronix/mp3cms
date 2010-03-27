# language: ru
Функционал: Топ скачанных файлов за последние 7 дней
  Чтобы знать какие файлы самые популярные
    Пользователи должны иметь возможность просматривать топ самых скачиваемых треков.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "user"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles |
     | petr       | petr@gmail.com       | secret   | true   | user  |
     | anna       | anna@gmail.com       | secret   | true   | user  |
    И есть следующие плейлисты:
     | title   | description         | user_email     |
     | Шансон  | Музыка шансон       | petr@gmail.com |
     | Разное  | Моя музыка          | anna@gmail.com |
    И загружены следующие треки:
          | title              | author       | playlist | user_email     | state  | count_downloads |
          | Городские встречи  | С. Наговицын | Шансон   | petr@gmail.com | active |             78  |
          | Девочка-проказница | С. Наговицын | Шансон   | petr@gmail.com | active |             63  |
          | Wind of change     | Scorpions    | Разное   | anna@gmail.com | active |             25  |
          | Send Me An Angel   | Scorpions    | Разное   | anna@gmail.com | active |             13  |
          | Музыка нас связала | Мираж        | Разное   | anna@gmail.com | active |              0  |

  Сценарий: Просмотр топа самых скачиваемых треков
    И я зашел в сервис как "petr@gmail.com/secret"
      И я на странице топа скачиваемых файлов
#И покажи страницу
      То я увижу следующие треки:
          | Название           | Исполнитель  | Скачано         |
          | Городские встречи  | С. Наговицын |             78  |
          | Девочка-проказница | С. Наговицын |             63  |
          | Wind of change     | Scorpions    |             25  |
          | Send Me An Angel   | Scorpions    |             13  |

