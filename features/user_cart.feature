# language: ru
Функционал: Работа с файлами (треками) со стороны пользователей
  Чтобы использовать сайт по назначению
    Пользователь должен иметь возможность просматривать, прослушивать, закачивать и скачивать файлы.

  Предыстория:
    Допустим в сервисе записана стоимости по умолчанию
      И в сервисе есть следующие роли пользователей "admin, user, moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles | balance |
     | petr       | petr@gmail.com       | secret   | true   | user  |       5 |
     | anna       | anna@gmail.com       | secret   | true   | user  |       5 |
    И есть следующие плейлисты:
     | title   | description         | user_email     |
     | Попса   | Попсовая подборка   | petr@gmail.com |
     | Шансон  | Музыка шансон       | petr@gmail.com |
     | Разное  | Моя музыка          | anna@gmail.com |

  Сценарий: Отправка пользователем понравившихся треков в корзину
      Допустим загружены в систему следующие треки:
          | title                 | author     | playlist | user_email     | state  | file_name                   |
          | Дяденька представляет | Наговицын  | Разное   | anna@gmail.com | active | dyadenka_predstavlyaet.mp3  |
          | Городские встречи     | Наговицын  | Разное   | anna@gmail.com | active | gorodskie_vstrechi.mp3      |
        И я зашел в сервис как "petr@gmail.com/secret"
      И я на главной странице
        Если я отмечу и отправлю в корзину треки "Дяденька представляет, Городские встречи"
        И я перейду по ссылке "Корзина"
          То я увижу "Дяденька представляет" в "#tracks"
          И я увижу "Городские встречи" в "#tracks"

  Сценарий: Массовое скачивание песен пользователем
      Допустим загружены в систему следующие треки:
          | title                 | author     | playlist | user_email     | state  | file_name                   |
          | Дяденька представляет | Наговицын  | Разное   | anna@gmail.com | active | dyadenka_predstavlyaet.mp3  |
          | Городские встречи     | Наговицын  | Разное   | anna@gmail.com | active | gorodskie_vstrechi.mp3      |
        И я зашел в сервис как "petr@gmail.com/secret"
      И я на главной странице
      Если я отправлю в корзину следующие треки:
          | Название              |
          | Дяденька представляет |
          | Городские встречи     |
        И я перейду по ссылке "Корзина"
          И я установлю флажок в "track_1"
          И я установлю флажок в "track_2"
      И я нажму "create_archive"
        #И покажи страницу
        То я должен быть на странице корзины
        #То я увижу "Архив успешно создан. Временная ссылка сгенерирована"
        И я увижу временную ссылку для скачивания архива
          И у пользователя "petr@gmail.com" было снятие баланса за скачивание трека
          И баланс пользователя "petr@gmail.com" равен "4.96"
      Если я перейду по временной ссылке для скачивания архива
        То начнется закачка архива на компьютер

  Сценарий: Удаление треков из корзины
      Допустим загружены в систему следующие треки:
          | title                 | author     | playlist | user_email     | state  | file_name                   |
          | Дяденька представляет | Наговицын  | Разное   | anna@gmail.com | active | dyadenka_predstavlyaet.mp3  |
          | Городские встречи     | Наговицын  | Разное   | anna@gmail.com | active | gorodskie_vstrechi.mp3      |
        И я зашел в сервис как "petr@gmail.com/secret"
      И я на главной странице
      Если я отправлю в корзину следующие треки:
          | Название              |
          | Дяденька представляет |
          | Городские встречи     |
        И я перейду по ссылке "Корзина"
          И я установлю флажок в "track_1"
          И я установлю флажок в "track_2"
      И я нажму "delete_tracks"
        #То я увижу "Треки удалены из корзины"
          То я не увижу "Wind of change" в "#tracks"
          И я не увижу "Send Me An Angel" в "#tracks"
            И я должен быть на странице корзины

