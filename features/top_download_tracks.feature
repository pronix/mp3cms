# language: ru
Функционал: Топ скачанных файлов за последние 7 дней
  Чтобы знать какие файлы самые популярные
    Пользователи должны иметь возможность просматривать топ самых скачиваемых треков.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles |
     | petr       | petr@gmail.com       | secret   | true   | user  |
     | anna       | anna@gmail.com       | secret   | true   | user  |
    И есть следующие плейлисты:
     | title   | description         | user_email     |
     | Шансон  | Музыка шансон       | petr@gmail.com |
     | Разное  | Моя музыка          | anna@gmail.com |
    И загружены следующие треки:
          |id| title              | author       | playlist | user_email     | state  | count_downloads |
          |1 | Городские встречи  | С. Наговицын | Шансон   | petr@gmail.com | active |             78  |
          |2 | Девочка-проказница | С. Наговицын | Шансон   | petr@gmail.com | active |             63  |
          |3 | Wind of change     | Scorpions    | Разное   | anna@gmail.com | active |             25  |
          |4 | Send Me An Angel   | Scorpions    | Разное   | anna@gmail.com | active |             13  |
          |5 | Музыка нас связала | Мираж        | Разное   | anna@gmail.com | active |              0  |
    И скачено "2" раза "Городские встречи"
    И скачено "6" раза "Девочка-проказница"
    И скачено "12" раза "Send Me An Angel"

  Сценарий: Просмотр топа самых скачиваемых треков
    И я зашел в сервис как "petr@gmail.com/secret"
      И я на странице топа скачиваемых файлов
      То я увижу следующие треки:
          | Название           | Исполнитель  | Скачано         |
          | Send Me An Angel   | Scorpions    |             12  |
          | Девочка-проказница | С. Наговицын |             6   |
          | Городские встречи  | С. Наговицын |             2   |


  Сценарий: Просмотра топа мп3 на главной
    И я зашел в сервис как "petr@gmail.com/secret"
    И я на главной странице сервиса
    И я увижу "Send Me An Angel" в "#top_mp3"
    И я увижу "Девочка-проказница" в "#top_mp3"
    И я увижу "Городские встречи" в "#top_mp3"

          
          

