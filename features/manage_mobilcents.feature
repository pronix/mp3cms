# language: ru
 Функционал: Пополнение баланса пользователем через mobolcents
   Пользователь на странице платежей должен иметь возможность сделать пополнение баланса с
   помошью смс через mobilcents.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator(id:3)"
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       | balance | webmoney_purse |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |       0 |                |
     | vlad  | vlad@gmail.com       | secret   | true   | user        |      11 | Z121212121212  |
     | inna  | inna@gmail.com       | secret   | true   | user        |       9 | Z232323232323  |
     И прописаны параметры платежного шлюза "mobilcents"

  Сценарий: На странице платежей пользователь должен увидеть ссылку на пополение серез mobilcents
    Допустим в сервисе записана стоимости по умолчанию
    И зашел в сервис как "inna@gmail.com/secret"
    И на главной странице сервиса
    Если я перешел на страницу "payments"
    То я увижу ссылку "mobilcents"

  Сценарий: Пользователь должен увидеть информацию для выполнения платежа (номер телефона, код смс)
  Сценарий: Баланс пользователя должен увеличиться как только пользователь введет вверный пароль.
  Сценарий: Баланс пользователя не должен увеличиться если пароль ошибочный.


