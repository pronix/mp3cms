# language: ru
Функционал: Работа с файлами (треками) со стороны пользователей
  Чтобы использовать сайт по назначению
    Пользователь должен иметь возможность просматривать, прослушивать, закачивать и скачивать файлы.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       |
     | petr       | petr@gmail.com       | secret   | true   | user        |
     | anna       | anna@gmail.com       | secret   | true   | user        |
    И есть следующие плейлисты:
     | title   | description         | user_email     |
     | Попса   | Попсовая подборка   | petr@gmail.com |
     | Шансон  | Музыка шансон       | petr@gmail.com |
     | Разное  | Моя музыка          | anna@gmail.com |

  Сценарий: Отправка пользователем понравившихся треков в корзину
      Допустим загружены следующие треки:
          | id | title            | author    | playlist | user_email     | state  |
          |  1 | Wind of change   | Scorpions | Разное   | anna@gmail.com | active |
          |  2 | Send Me An Angel | Scorpions | Разное   | anna@gmail.com | active |
        И я зашел в сервис как "petr@gmail.com/secret"
      И я на главной странице
        Если я установлю флажок в "track_1"
        И я установлю флажок в "track_2"
      И я нажму "В корзину"
      То я должен быть на главной странице
      Если я перейду по ссылке "Корзина"
        То я увижу "Wind of change" в "#tracks"
        И я увижу "Send Me An Angel" в "#tracks"

  Сценарий: Массовое скачивание песен пользователем
      Допустим загружены следующие треки:
          | title              | author       | playlist | user_email     | state  |
          | Wind of change     | Scorpions    | Разное   | anna@gmail.com | active |
          | Send Me An Angel   | Scorpions    | Разное   | anna@gmail.com | active |
        И я зашел в сервис как "petr@gmail.com/secret"
      И я на главной странице
      Если я отправлю в корзину следующие треки:
          | Название          |
          | Wind of change    |
          | Send Me An Angel  |
        И я перейду по ссылке "Корзина"
      И я нажму "create_archive"
        То я увижу "Архив успешно создан. Временная ссылка сгенерирована"
        И я увижу временную ссылку для скачивания архива
      Если я перейду по временной ссылке для скачивания архива
        То начнется закачка архива на компьютер

