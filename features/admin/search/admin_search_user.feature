# language: ru

@no-txn @green
Функционал: Поиск в административной панели по пользователям
Поиск по логину, мылу, кошельку, айпи, айди.

  Предыстория:
   Допустим в сервисе есть следующие роли пользователей "admin(admin:true), user, moderator"
    И в сервисе есть следующие пользователи:
 | login | email                | password | active | roles       | last_login_ip | current_login_ip | id | balance | webmoney_purse |
 | admin | admin_user@gmail.com | secret   | true   | user, admin |   234.221.4.1 |      234.221.4.1 |  1 |      10 | Z111111111111  |
 | petr  | petr@gmail.com       | secret   | true   | user        |   234.221.4.2 |      234.221.4.2 |  2 |      20 | Z222222222222  |
 | anna  | anna@gmail.com       | secret   | true   | user        |   234.221.4.3 |      234.221.4.2 |  3 |      30 | Z333333333333  |
    И обновляем индексы Sphinx
    И я зашел в сервис как "admin_user@gmail.com/secret"
    И я на странице "поиск пользователей в админке"

  Сценарий: Поиск а админке пользователей по логину, по email,по id, по ip, по кошельку
    Допустим я введу в поле "q" значение "petr" в "#form_user"
    И я выберу "attribute_login"
    И я нажму "search_user"
    То я увижу "petr"
    Допустим я введу в поле "q" значение "petr@gmail.com" в "#form_user"
    И я выберу "attribute_email"
    И я нажму "search_user"
    То я увижу "petr"
    Допустим я введу в поле "q" значение "2" в селекторе "#form_user"
    И я выберу "attribute_id" в "#form_user"
    И я нажму "search_user" в "#form_user"
    То я увижу "petr"
    Допустим я введу в поле "q" значение "234.221.4.2" в селекторе "#form_user"
    И я выберу "attribute_ip" в "#form_user"
    И я нажму "search_user" в "#form_user"
    То я увижу "petr"
    И я увижу "anna"
    И я не увижу "admin"
    Допустим я введу в поле "q" значение "Z222222222222" в селекторе "#form_user"
    И я выберу "attribute_balance" в "#form_user"
    И я нажму "search_user" в "#form_user"
    То я увижу "petr"
    И я не увижу "anna"

  Сценарий: Поиск а админке пользователей с нулевым запросом в поле, с нулевым ответом
    Допустим я введу в поле "q" значение "" в селекторе "#form_user"
    И я нажму "search_user" в "#form_user"
    То я увижу "По вашему запросу ничего не найденно"
    Допустим я введу в поле "q" значение "фоыврафлоыварлфыова"
    И я нажму "search_user" в "#form_user"
    То я увижу "По вашему запросу ничего не найденно"

