# language: ru
Функционал: Просмотр статистики по серверу
  Админ должен видеть графики по сетевой и дисковой активности

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
    И в сервисе есть следующие пользователи:
     | login  | email            | password | active | roles | balance | webmoney_purse |
     | admin  | admin@gmail.com  | secret   | true   | admin |       0 | Z121212121212  |
     | vlad   | vlad@gmail.com   | secret   | true   | user  |      30 | Z222222222222  |

  Сценарий: Статистика не доступна пользователям
    Допустим я зашел в сервис как "vlad@gmail.com/secret"
    И перешел на страницу "admin_satellites"
    То я увижу "Вы не имеете прав для просмотра данной страницы."





