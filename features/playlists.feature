# language: ru
Функционал: Плейлисты
  Для того, чтобы пользователи сервиса могли создавать свои подборки музыки (плейлисты), должна быть возможность управления ими.
  Кол-во подборок не ограничено. Плейлисты будут доступны всем пользователям включая гостей (для просмотра).
  У плейлиста есть название, изображение (автоматически уменьшать до 120х120), краткое описание и список треков.
  Страница списка плейлистов выводит по странично все плейлисты.

  Сценарий: Просмотр плейлистов гостем на сайте
    Допустим существуют плейлисты:
       | title  | description       |
       | Попса  | Попсовая подборка |
       | Шансон | Музыка шансон     |
         И я на главной странице сайта
    Если я перейду по ссылке "Плейлисты"
    То я увижу "Попса" в "#playlist_1"
      И я увижу "Шансон" в "#playlist_1"

  Сценарий: Создание плейлистов пользователем
    Допустим я вошел в систему как "pupkin@google.com"
      И я на странице учетной записи "pupkin@google.com"
    Если я перейду по ссылке "Плейлисты"

