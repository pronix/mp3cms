# language: ru
Функционал: Управление плейлистами сайта
  Администратор должен иметь возможность управлять всеми плейлистами в сервисе.
  Пользователь должен иметь возможность управлять своими плейлистами в сервисе.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       |
     | admin_user | admin_user@gmail.com | secret   | true   | user, admin |
     | petr       | petr@gmail.com       | secret   | true   | user        |
     | anna       | anna@gmail.com       | secret   | true   | user        |
            И есть следующие плейлисты:
             | title   | description         | user_email     |
             | Попса   | Попсовая подборка   | anna@gmail.com |
             | Шансон  | Музыка шансон       | anna@gmail.com |
             | Клубняк | Клубная музыка      | petr@gmail.com |
             | Металл  | Неформальная музыка | petr@gmail.com |

  Сценарий: Просмотр списка плейлистов администратором в админке
    Если я зашел в сервис как "admin_user@gmail.com/secret"
      И я на странице управления плейлистами
      То я увижу следующие плейлисты:
             | title      |
             | Металл     |
             | Клубняк    |
             | Шансон     |
             | Попса      |

  Сценарий: Просмотр списка плейлистов пользователем в админке
    Если я зашел в сервис как "petr@gmail.com/secret"
      И я на странице управления плейлистами
      То я увижу следующие плейлисты:
             | title      |
             | Металл     |
             | Клубняк    |

  Сценарий: Просмотр плейлистов пользователем на странице плейлистов
    Если я зашел в сервис как "petr@gmail.com/secret"
      И я на странице плейлистов
      То я увижу следующие плейлисты:
               | title      |
               | Металл     |
               | Клубняк    |
               | Шансон     |
               | Попса      |

  Сценарий: Просмотр плейлиста в админке управления плейлистами
    Допустим есть следующие плейлисты:
             | title   | description   | user_email     |
             | Разное  | Разная музыка | petr@gmail.com |
          И я зашел в сервис как "petr@gmail.com/secret"
      И я на странице управления плейлистами
      И я перейду по ссылке "Разное"
      То я увижу "Разное"
        И я увижу "Разная музыка" в "#description"
      И я должен быть на странице админки просмотра плейлиста "Разное"

  Сценарий: Создание плейлиста пользователем
    Если я зашел в сервис как "petr@gmail.com/secret"
      И я перейду по ссылке "playlist_new"
      И я введу в поле "playlist[title]" значение "Популярная музыка"
      И я прикреплю файл "test/images/vodka-net.gif" в поле "playlist[icon]"
        И я нажму "playlist_submit"
      То будет сообщение "Плейлист создан"
        И я увижу "Популярная музыка"
        И плейлист "Популярная музыка" принадлежит пользователю "petr@gmail.com"
      И я должен быть на странице админки просмотра плейлиста "Популярная музыка"

  Сценарий: Редактирование плейлиста
    Если я зашел в сервис как "admin_user@gmail.com/secret"
      И я на странице управления плейлистами
      Если я перейду по ссылке "Металл"
        И я перейду по ссылке "playlist_edit"
      И я введу в поле "playlist[title]" значение "Редкая музыка"
        И я нажму "playlist_submit"
      То будет сообщение "Плейлист обновлен"
        И я увижу "Редкая музыка"
          И я не увижу "Металл"
      И я должен быть на странице админки просмотра плейлиста "Редкая музыка"

  Сценарий: Удаление плейлиста
    Если я зашел в сервис как "admin_user@gmail.com/secret"
      И я на странице управления плейлистами
      Если я перейду по ссылке "Металл"
        И я перейду по ссылке "playlist_edit"
        И я перейду по ссылке "playlist_delete"
      То будет сообщение "Плейлист удален"
        И я не увижу "Металл" в "#playlists"
        И я увижу следующие плейлисты:
               | title      |
               | Клубняк    |
               | Шансон     |
               | Попса      |
        И я должен быть на странице управления плейлистами

  Сценарий: Попытка доступа к управлению плейлистами гостя на сайте
      Допустим я вышел из системы
        То мне разрешен просмотр списка плейлистов
          И мне запрещено посещение админки управления плейлистами
        И мне разрешен просмотр плейлистов
        И мне запрещено создание плейлистов
        И мне запрещено редактирование плейлистов
        И мне запрещено удаление плейлистов

  Сценарий: Попытка доступа пользователя к плейлистам другого пользователя
      Допустим я зашел в сервис как "petr@gmail.com/secret"
        То мне разрешен просмотр списка плейлистов
          И мне разрешено посещение админки управления плейлистами
        И мне разрешен просмотр плейлистов
        И мне разрешено создание плейлистов
          И мне разрешено редактирование плейлистов пользователя "petr"
          И мне разрешено удаление плейлистов пользователя "petr"
            И мне запрещено редактирование плейлистов пользователя "anna"
            И мне запрещено удаление плейлистов пользователя "anna"

  Сценарий: Администратор управляет любыми плейлистами
      Допустим я зашел в сервис как "admin_user@gmail.com/secret"
        То мне разрешен просмотр списка плейлистов
          И мне разрешено посещение админки управления плейлистами
        И мне разрешен просмотр плейлистов
        И мне разрешено создание плейлистов
          И мне разрешено редактирование плейлистов пользователя "petr"
          И мне разрешено удаление плейлистов пользователя "petr"
            И мне разрешено редактирование плейлистов пользователя "anna"
            И мне разрешено удаление плейлистов пользователя "anna"

