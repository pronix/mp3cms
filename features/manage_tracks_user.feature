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

#  Сценарий: Загрузка файлов по фтп
#      Если я загружу новый файл "Туман_туманище.mp3" по фтп
#      И трек "Туман_туманище" пройдет модерацию
#        То я увижу "Туман_туманище" в списке моих треков

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
      Если я перейду по ссылке "track_1_delete"
        То будет сообщение "Трек удален"
          И я не увижу "Музыка нас связала" в "#tracks"
          И я должен быть на странице админки просмотра плейлиста "Попса"

  Сценарий: Скачивание файла пользователем
      Допустим загружены следующие треки:
          | title | author | playlist | user_email     | state  |
          | Ночь  | Мираж  | Разное   | anna@gmail.com | active |
      И я зашел в сервис как "petr@gmail.com/secret"
      Если я на странице просмотра плейлиста "Разное"
      И я перейду по ссылке "Ночь"
        То я должен быть на странице скачивания файла "Ночь"
      Если я перейду по ссылке "generate_link"
        То я увижу временную ссылку на скачивание
      Если я перейду по временной ссылке
        То я скачаю файл себе на компьютер
      Если я на странице скачивания файла "Ночь"
        То я не увижу ссылку генерации
        Если я попытаюсь сгенерировать ссылку для скачивания трека "Ночь"
          То будет сообщение "Невозможно сгенерировать ссылку"

#  Сценарий: Массовое скачивание песен пользователем
      #То покажи страницу
#      Если я отправлю в корзину файлы "Wind of change, Send Me An Angel"
#        И я перейду по ссылке "Корзина"
#      То я увижу "Wind of change" в корзине
#        И я увижу "Send Me An Angel" в корзине
#      Если я перейду по ссылке создания архива для скачивания
#        То я увижу ссылку для скачивания
#      Если я перейду по ссылке для скачивания
#        То я скачаю архив себе на компьютер

