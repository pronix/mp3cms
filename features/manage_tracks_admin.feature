# language: ru
Функционал: Работа с файлами (треками) со стороны админа
  Чтобы не допустить попадания песен, запрещенных законодательством РФ
    Администратор должен иметь возможность управления (модерации) музыкальных файлов системы.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       |
     | admin      | admin_user@gmail.com | secret   | true   | user, admin |
     | petr       | petr@gmail.com       | secret   | true   | user        |
     | anna       | anna@gmail.com       | secret   | true   | user        |
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
      Если я перейду по ссылке "Забаненные"
        И установлю флажок "track_ids[]" в "#track_3"
        И установлю флажок "track_ids[]" в "#track_4"
          И я нажму "active"
          То файлы "Городские встречи, Девочка-проказница" будут активными
      Если я перейду по ссылке "Активные"
        И установлю флажок "track_ids[]" в "#track_1"
        И установлю флажок "track_ids[]" в "#track_2"
          И я нажму "delete"
          То файлы "Городские встречи, Девочка-проказница" будут удалены

  Сценарий: Редактирование файлов администратором
      Если я перейду по ссылке "track_edit" в "#track_1_author"
        И я введу в поле "track_title" значение "Гарадские фстречи"
        И я введу в поле "track_author" значение "Нагавицын"
          И я нажму "track_submit"
      То я должен быть на странице управления треками
        И будет сообщение "Трек обновлен"
        И я увижу следующие треки:
            | Исполнитель   | Название            |
            | С. Наговицын  | Девочка-проказница  |
            | Нагавицын     | Гарадские фстречи   |

  #Сценарий: Абузы ????????????????????????????????
  #    Че это такое непонятно!!!!!

