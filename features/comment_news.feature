# language: ru
 Функционал: Комментарии к новостям


  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |

    И в сервисе есть следующие новости
  | id | header         | meta  | text | description | state |
  | 1  | Открыт новый сервис на проекте  | Вы можете заработать | Зарабатывайте вместе с нами  | Новый сервис рулит | active |
  | 2  | Топ10 нашего сайта    | Признан самым актуальным | Независимый источник признал наш Топ10 | Top10 рулит | active |
  | 3  | 100 топовый треков прошлого года | Что признал народ | Статистика скаченных треков за прошлый год | Статистика дескрипшен | active |


Сценарий: Создание комментария
  И я зашел в сервис как "admin_user@gmail.com/secret"
  И я на "главной странице сервиса"
  И я перейду по ссылке "Открыт новый сервис на проекте"
  То я введу в поле "comment[name]" значение "name_text"
  То я введу в поле "comment[email]" значение "email_text"
  И я введу в поле "comment[comment]" значение "comment_text"
  И правильно ввел капчу для комментария
  И я нажму "Создать"
  И я увижу "name_text"
  И я увижу "email_text"
  И я увижу "comment_text"

Сценарий: Создание комментария с не зарегистрированным пользователем
  И я на "главной странице сервиса"
  И я перейду по ссылке "Открыт новый сервис на проекте"
  И я не увижу "Comment*"
