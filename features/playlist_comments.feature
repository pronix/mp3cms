# language: ru
Функционал: Комментирование плейлистов
  Для того, чтобы пользователи сервиса могли высказать свое мнение
  Должна быть возможность просмотра и управления комментариями плейлистов.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       |
     | admin_user | admin_user@gmail.com | secret   | true   | user, admin |
     | anna       | anna@gmail.com       | secret   | true   | user        |
     | ivan       | ivan@gmail.com       | secret   | true   | user        |
     | petr       | petr@gmail.com       | secret   | true   | user        |
            И есть следующие плейлисты:
             | title   | description         | user_email     |
             | Шансон  | Музыка шансон       | petr@gmail.com |
            И есть следующие комментарии плейлистов:
             | user_email     | title   | comment           | playlist |
             | anna@gmail.com | Оценка1 | Хорошая подборка  | Шансон   |
             | ivan@gmail.com | Оценка2 | Плохая подборка   | Шансон   |
             | petr@gmail.com | Оценка3 | Блин я старался   | Шансон   |

  Сценарий: Просмотр списка комментариев пользователем
    Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице просмотра плейлиста "Шансон"
              То я увижу следующие комментарии:
                     | Автор | Название | Комментарий      |
                     | petr  | Оценка3  | Блин я старался  |
                     | ivan  | Оценка2  | Плохая подборка  |
                     | anna  | Оценка1  | Хорошая подборка |

  Сценарий: Добавление комментария
    Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице просмотра плейлиста "Шансон"
      Если я введу в поле "comment[comment]" значение "Хороший вкус дружище!"
        И я нажму "comment_submit"
      То будет сообщение "Комментарий создан"
        И я увижу "Хороший вкус дружище!" в "#comments"
        И я должен быть на странице просмотра плейлиста "Шансон"

  Сценарий: Редактирование своего комментария пользователем
    Допустим я зашел в сервис как "petr@gmail.com/secret"
      И я на странице просмотра плейлиста "Шансон"
        Если я перейду по ссылке "comment_1_edit"
        И я введу в поле "comment[comment]" значение "Еще создам лист"
          И я нажму "comment_submit"
        То будет сообщение "Комментарий обновлен"
          И я увижу "Еще создам лист" в "#comment_1"
          И я должен быть на странице просмотра плейлиста "Шансон"

  Сценарий: Удаление комментария
    Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице просмотра плейлиста "Шансон"
          Если я перейду по ссылке "comment_1_delete"
          То будет сообщение "Комментарий удален"
          И я не увижу "Блин я старался" в "#comments"
            И я должен быть на странице просмотра плейлиста "Шансон"
                    И я увижу следующие комментарии:
                           | Автор | Название | Комментарий      |
                           | ivan  | Оценка2  | Плохая подборка  |
                           | anna  | Оценка1  | Хорошая подборка |

  Сценарий: Попытка доступа к управлению комментариями гостем на сайте
    Допустим я вышел из системы
      То мне разрешен просмотр списка комментариев плейлистов
      И мне запрещено создание комментариев плейлистов
      И мне запрещено редактирование комментариев плейлистов
      И мне запрещено удаление комментариев плейлистов

  Сценарий: Попытка доступа пользователя к комментариям другого пользователя
      Допустим я зашел в сервис как "petr@gmail.com/secret"
        И я на странице просмотра плейлиста "Шансон"
          То мне разрешен просмотр списка комментариев плейлистов
          И мне разрешено создание комментариев плейлистов
            И мне разрешено редактирование комментариев плейлистов пользователя "petr"
            И мне разрешено удаление комментариев плейлистов пользователя "petr"
              И мне запрещено редактирование комментариев плейлистов пользователя "anna"
              И мне запрещено удаление комментариев плейлистов пользователя "anna"

