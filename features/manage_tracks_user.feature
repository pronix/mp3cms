# language: ru
Функционал: Работа с файлами (треками) со стороны пользователей
  Чтобы использовать сайт по назначению
    Пользователь должен иметь возможность просматривать, прослушивать, закачивать и скачивать файлы.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
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
          | Название           | Исполнитель  | Битрейт | Размер  |
          | Музыка нас связала | Мираж        | 320     | 277025  |
          | Наше время пришло  | Комиссар     | 320     | 277025  |
      Если я на странице админки просмотра плейлиста "Шансон"
      То я увижу следующие треки:
          | Название           | Исполнитель  | Битрейт | Размер  |
          | Городские встречи  | С. Наговицын | 320     | 277025  |
          | Девочка-проказница | С. Наговицын | 320     | 277025  |

  Сценарий: Загрузка одиночного файла пользователем
      Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице админки просмотра плейлиста "Попса"
      Если я введу в поле "track[title]" значение "Звезды нас ждут"
        И я введу в поле "track[author]" значение "Мираж"
        И я прикреплю файл "test/files/file.mp3" в поле "track[data]"
        И я нажму "track_submit" в "#data_file"
      То будет сообщение "Трек отправлен на модерацию"
      И я должен быть на странице админки просмотра плейлиста "Попса"
      Если трек "Звезды нас ждут" пройдет модерацию
        То я увижу песню "Звезды нас ждут" в плейлисте "Попса"
        И размер песни "Звезды нас ждут" будет 277025 б
        И битрейт песни "Звезды нас ждут" будет 320 кбит/с

  Сценарий: Загрузка нескольких файлов пользователем с компьютера
      Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице админки просмотра плейлиста "Попса"
      Если я перейду по ссылке "add_multi_form"
      И я прикреплю 10 файлов в поле "track_1[data]"
        И я нажму "track_submit"
      То будет сообщение "Треки отправлены на модерацию"
      Если треки пройдут модерацию
        То я увижу 10 новых треков в "#tracks"

#  Сценарий: Загрузка файлов по фтп
#      Если я загружу новый файл "Туман_туманище.mp3" по фтп
#      И трек "Туман_туманище" пройдет модерацию
#        То я увижу "Туман_туманище" в списке моих треков

  Сценарий: Загрузка файла пользователем по прямой ссылке
      Допустим я зашел в сервис как "petr@gmail.com/secret"
      И я на странице админки просмотра плейлиста "Попса"
      #Если я перейду по ссылке "track_http_new"
      Если я введу в поле "track[data_url]" значение "http://djstrex.com/ringtones/walking_away.mp3"
        И я нажму "track_submit" в "#data_url"
      То будет сообщение "Трек отправлен на модерацию"
        И я должен быть на странице админки просмотра плейлиста "Попса"
      Если трек "Walking Away" пройдет модерацию
        То я увижу песню "Walking Away" в плейлисте "Попса"

#  Сценарий: Удаление файла пользователем
#      Если я перейду по ссылке "track_1_delete"
#      То будет сообщение "Трек удален"
#        И я не увижу "Музыка нас связала" в "#tracks"
#          | Название           | Исполнитель  | Битрейт | Размер | Плейлист | Владелец |
#          | Наше время пришло  | Комиссар     | 192     | 85000  | Попса    | petr     |
#          | Городские встречи  | С. Наговицын | 128     | 98234  | Шансон   | petr     |
#          | Девочка-проказница | С. Наговицын | 128     | 26000  | Шансон   | petr     |
#        И я должен быть на странице управления треками

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

