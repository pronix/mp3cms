# language: ru
Функционал: Работа с файлами (треками) со стороны админа
  Чтобы не допустить попадания песен, запрещенных законодательством РФ
    Администратор должен иметь возможность управления (модерации) музыкальных файлов системы.

  Предыстория:
    Допустим в сервисе записана стоимости по умолчанию
      И в сервисе есть следующие роли пользователей "admin, user, moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       | balance |
     | admin      | admin_user@gmail.com | secret   | true   | user, admin |       5 |
     | petr       | petr@gmail.com       | secret   | true   | user        |       5 |
     | anna       | anna@gmail.com       | secret   | true   | user        |       5 |
    И есть следующие плейлисты:
     | title   | description         | user_email     |
     | Попса   | Попсовая подборка   | petr@gmail.com |
     | Шансон  | Музыка шансон       | petr@gmail.com |
     | Разное  | Моя музыка          | anna@gmail.com |
    И загружены следующие треки:
          | title              | author       | playlist | user_email     | state      |
          | Музыка нас связала | Мираж        | Попса    | petr@gmail.com | active     |
          | Наше время пришло  | Комиссар     | Попса    | petr@gmail.com | active     |
          | Городские встречи  | С. Наговицын | Шансон   | petr@gmail.com | moderation |
          | Девочка-проказница | С. Наговицын | Шансон   | petr@gmail.com | moderation |
          | Wind of change     | Scorpions    | Разное   | anna@gmail.com | banned     |
          | Send Me An Angel   | Scorpions    | Разное   | anna@gmail.com | banned     |
      И я зашел в сервис как "admin_user@gmail.com/secret"
      И я на странице управления треками

  Сценарий: Просмотр списка файлов по статусам
      То я увижу следующие треки:
            | author       | title              |
            | С. Наговицын | Городские встречи  |
            | С. Наговицын | Девочка-проказница |
      Если я перейду по ссылке "Активные"
        То я увижу следующие треки:
            | Исполнитель  | Название           |
            | Мираж        | Музыка нас связала |
            | Комиссар     | Наше время пришло  |
      Если я перейду по ссылке "Забаненные"
        То я увижу следующие треки:
            | Исполнитель | Название         |
            | Scorpions   | Wind of change   |
            | Scorpions   | Send Me An Angel |

  Сценарий: Модерация новых файлов массово
      Если я установлю флажок "track_ids[]" в "#track_1"
        И установлю флажок "track_ids[]" в "#track_2"
          И я нажму "banned"
          То файлы "Городские встречи, Девочка-проказница" будут забанены
            И в забаненных треках появятся хэши треков "Городские встречи, Девочка-проказница"
      Если я перейду по ссылке "Забаненные"
        И установлю флажок "track_ids[]" в "#track_3"
        И установлю флажок "track_ids[]" в "#track_4"
          И я нажму "active"
          То файлы "Городские встречи, Девочка-проказница" будут активными
              И у пользователя "petr@gmail.com" было пополнение баланса за загрузку нормального трека
                # Баланс увеличился засчет двойного пополнения баланса за выгрузку двух нормальных треков
                И баланс пользователя "petr@gmail.com" равен "5.2"
      Если я перейду по ссылке "Активные"
        И установлю флажок "track_ids[]" в "#track_1"
        И установлю флажок "track_ids[]" в "#track_2"
          И я нажму "delete"
          То файлы "Городские встречи, Девочка-проказница" будут удалены

  Сценарий: Редактирование файлов администратором
      Если я перейду по ссылке "track_2_edit"
        И я введу в поле "track_title" значение "Гарадские фстречи"
        И я введу в поле "track_author" значение "Нагавицын"
          И я нажму "track_submit"
      То я должен быть на странице управления треками
        И будет сообщение "Трек обновлен"
        И я увижу следующие треки:
            | Исполнитель   | Название            |
            | С. Наговицын  | Девочка-проказница  |
            | Нагавицын     | Гарадские фстречи   |

  Сценарий: Абузы
      Если я на странице управления абузами
        И я введу в поле "[track_links]" ссылки для треков "Музыка нас связала, Наше время пришло"
        И я нажму "Показать таблицу"
      То будет сообщение "Таблица создана"
        #И покажи страницу
        И я увижу следующие треки:
          | Музыка нас связала | Мираж    |
          | Наше время пришло  | Комиссар |

