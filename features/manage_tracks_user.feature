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

  Сценарий: Просмотр списка своих файлов в плейлисте пользователем сайта
      Допустим загружены следующие треки:
          | title              | author       | playlist | user_email     | state  |
          | Музыка нас связала | Мираж        | Попса    | petr@gmail.com | active |
          | Наше время пришло  | Комиссар     | Попса    | petr@gmail.com | active |
          | Городские встречи  | С. Наговицын | Шансон   | petr@gmail.com | active |
          | Девочка-проказница | С. Наговицын | Шансон   | petr@gmail.com | active |
          | Wind of change     | Scorpions    | Разное   | anna@gmail.com | active |
          | Send Me An Angel   | Scorpions    | Разное   | anna@gmail.com | active |
        И я зашел в сервис как "petr@gmail.com/secret"
        И я на странице админки просмотра плейлиста "Попса"
      То я увижу следующие треки:
          | Название           | Исполнитель  |
          | Музыка нас связала | Мираж        |
          | Наше время пришло  | Комиссар     |
      Если я на странице админки просмотра плейлиста "Шансон"
      То я увижу следующие треки:
          | Название           | Исполнитель  |
          | Городские встречи  | С. Наговицын |
          | Девочка-проказница | С. Наговицын |

  Сценарий: Загрузка одиночного файла пользователем
      Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице админки просмотра плейлиста "Попса"
      Если я введу в поле "track_1[title]" значение "Звезды нас ждут"
        И я введу в поле "track_1[author]" значение "Мираж"
        И я прикреплю файл "test/files/normal.mp3" в поле "track_1[data]"
        И я нажму "track_submit" в "#data_file"
      То будет сообщение "Отправлено на модерацию"
        И я должен быть на странице админки просмотра плейлиста "Попса"
      Если трек "Звезды нас ждут" пройдет модерацию
        То я увижу песню "Звезды нас ждут" в плейлисте "Попса"
        И размер песни "Звезды нас ждут" будет 8643969 б
        И битрейт песни "Звезды нас ждут" будет 256 кбит/с

  Сценарий: Определение и проставление правильной кодировки по тегам трека
      Допустим загружены в систему следующие треки:
          | playlist | user_email     | state  | file_name           |
          | Попса    | petr@gmail.com | active | other_encoding.mp3  |
        И я зашел в сервис как "petr@gmail.com/secret"
        И я на странице админки просмотра плейлиста "Попса"
      То я увижу следующие треки:
          | Название | Исполнитель      |
          | Пацаны   | Александр Дюмин  |

  Сценарий: Попытка загрузки файла пользователем без тега
      Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице админки просмотра плейлиста "Попса"
      Если я введу в поле "track_1[title]" значение "Звезды нас ждут"
        И я прикреплю файл "test/files/failed_tag.mp3" в поле "track_1[data]"
        И я нажму "track_submit" в "#data_file"
      То я должен быть на странице админки просмотра плейлиста "Попса"
        И я не увижу "Звезды нас ждут" в "#tracks"

  Сценарий: Попытка загрузки файла пользователем с битрейтом меньше 128
      Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице админки просмотра плейлиста "Попса"
      Если я введу в поле "track_1[title]" значение "Звезды нас ждут"
        И я прикреплю файл "test/files/invalid_bitrate.mp3" в поле "track_1[data]"
        И я нажму "track_submit" в "#data_file"
      То я должен быть на странице админки просмотра плейлиста "Попса"
        И я не увижу "Звезды нас ждут" в "#tracks"

  Сценарий: Загрузка нескольких файлов пользователем с компьютера
      Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице админки просмотра плейлиста "Попса"
      Если я перейду по ссылке "add_form"
        И я прикреплю 2 файла
        И я нажму "track_submit"
      То будет сообщение "Отправлено на модерацию"
        И я увижу 2 новых трека на странице

  Сценарий: Загрузка файла пользователем по прямой ссылке
      Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице админки просмотра плейлиста "Попса"
      Если я введу в поле "data_url" значение "http://djstrex.com/ringtones/walking_away.mp3"
        И я нажму "track_submit" в "#data_url_block"
      То будет сообщение "Загрузка поставлена в очередь на выполнение"
        И я должен быть на странице админки просмотра плейлиста "Попса"
      Если задача будет запущена
      И трек "Walking Away" пройдет модерацию
        То я увижу песню "Walking Away" в плейлисте "Попса"

  Сценарий: Удаление файла пользователем
      Допустим загружены следующие треки:
          | title              | author       | playlist | user_email     | state  |
          | Музыка нас связала | Мираж        | Попса    | petr@gmail.com | active |
          | Наше время пришло  | Комиссар     | Попса    | petr@gmail.com | active |
        И я зашел в сервис как "petr@gmail.com/secret"
        И я на странице админки просмотра плейлиста "Попса"
#И покажи страницу
      Если я перейду по ссылке "track_1_delete"
        То будет сообщение "Трек удален"
          И я не увижу "Музыка нас связала" в "#tracks"
          И я должен быть на странице админки просмотра плейлиста "Попса"

  Сценарий: Скачивание файлов пользователем
      Допустим загружены в систему следующие треки:
          | title | author | playlist | user_email     | state  |
          | Ночь  | Мираж  | Разное   | anna@gmail.com | active |
      И я зашел в сервис как "petr@gmail.com/secret"
      Если я на странице просмотра трека "Ночь"
        И я перейду по ссылке "generate_link"
        То я увижу временную ссылку на скачивание
          И счетчик скачивания файла "Ночь" будет равен "1"
          И у пользователя "petr@gmail.com" было снятие баланса за скачивание трека
          И баланс пользователя "petr@gmail.com" равен "4.98"
      Если я перейду по временной ссылке формата "mp3"
        То начнется закачка файла "normal.mp3" на компьютер
      Если я на странице скачивания файла "Ночь"
        И я перейду по временной ссылке формата "doc"
        То начнется закачка файла "normal.doc" на компьютер
      Если я на странице скачивания файла "Ночь"
        И я перейду по временной ссылке формата "rar"
        То начнется закачка файла "normal.rar" на компьютер
      Если я на странице скачивания файла "Ночь"
        И я перейду по временной ссылке формата "txt"
        То начнется закачка файла "normal.txt" на компьютер
      Если я на странице скачивания файла "Ночь"
        То я не увижу ссылку генерации
        Если я попытаюсь сгенерировать ссылку для скачивания трека "Ночь"
          То будет сообщение "Невозможно сгенерировать ссылку"

  Сценарий: Отправка пользователем понравившихся треков в плейлист
      Допустим загружены следующие треки:
          | title              | author       | playlist | user_email     | state  |
          | Wind of change     | Scorpions    | Разное   | anna@gmail.com | active |
          | Send Me An Angel   | Scorpions    | Разное   | anna@gmail.com | active |
        И я зашел в сервис как "petr@gmail.com/secret"
      И я на главной странице
        Если я установлю флажок в "track_1"
        И я установлю флажок в "track_2"
      И я выберу "Попса" из "[playlist_id]"
      И я нажму "OK"
      Если я на странице плейлистов
        И я перейду по ссылке "Разное"
      То я увижу "Wind of change" в "#tracks"
      И я увижу "Send Me An Angel" в "#tracks"

  Сценарий: Попытка доступа к управлению треками гостя на сайте
      Допустим я вышел из системы
        То мне разрешен просмотр списка треков
          И мне разрешен просмотр новых треков
          И мне разрешен просмотр топа треков
        И мне запрещено посещение админки управления треками
        И мне запрещено посещение админки плейлистов для управления треками
        И мне разрешен просмотр треков
        И мне запрещено создание треков
        И мне запрещено редактирование треков
        И мне запрещено удаление треков

  Сценарий: Попытка доступа пользователя к трекам другого пользователя
      Допустим я зашел в сервис как "petr@gmail.com/secret"
        То мне разрешен просмотр списка треков
          И мне разрешен просмотр новых треков
          И мне разрешен просмотр топа треков
        И мне запрещено посещение админки управления треками
        И мне разрешен просмотр треков
        И мне разрешено создание треков
          И мне разрешено редактирование треков пользователя "petr"
          И мне разрешено удаление треков пользователя "petr"
            И мне запрещено редактирование треков пользователя "anna"
            И мне запрещено удаление треков пользователя "anna"

