# language: ru
Функционал: Главная страница сервиса

  Сценарий: Выдача сообщение блокировки ип адреса если адрес в списке заблокированных
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
     И в сервисе есть следующие пользователи:
     | id | login | email                | password | active | roles | balance | current_login_ip |
     |  1 | admin | admin_user@gmail.com | secret   | true   | admin |       0 |      123.11.1.11 |
     |  2 | anna  | anna@gmail.com       | secret   | true   | user  |      23 |      123.11.12.1 |
     |  3 | petr  | petr@gmail.com       | secret   | true   | user  |      43 |    123.11.12.101 |
     |  4 | vlad  | vlad@gmail.com       | secret   | true   | user  |      43 |        127.0.0.1 |
     И пользователь "vlad@gmail.com" заблокирован по ип адресу "127.0.0.1"
    Если я перешел на главную страницу сервиса
    То я увижу "Ваш адрес заблокирован"
