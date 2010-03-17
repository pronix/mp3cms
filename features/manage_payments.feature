# language: ru
 Функционал: Транзакции пользователя.
   Авторизованый пользователь может просмотривать  свои транзакции по доходам и расходам,
   также пополнять свой баланс и подавать заявку на вывод денег.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator(id:3)"
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       | balance |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |      0  |
     | vlad  | vlad@gmail.com       | secret   | true   | user        |      10 |
     | inna  | inna@gmail.com       | secret   | true   | user        |      10 |

     И в сервисе записана стоимости по умолчанию
     И есть следующие транзакции в сервиса:
    | date_transaction | user           | amount | type_transaction | kind_transaction | type_payment |
    |       01.02.2010 | vlad@gmail.com |    0.1 | credit           | find_track       | internal     |
    |       02.02.2010 | vlad@gmail.com |   0.02 | credit           | add_news         | internal     |
    |       02.02.2010 | vlad@gmail.com |   0.02 | credit           | add_news         | internal     |
    |       03.02.2010 | vlad@gmail.com |    0.2 | debit            | download_track   | internal     |
    |       01.03.2010 | vlad@gmail.com |    0.2 | debit            | download_track   | internal     |
    |       01.03.2010 | vlad@gmail.com |    0.2 | debit            | download_track   | internal     |


  Сценарий: Попытка просмотра не авторизованным пользователем
    Допустим я на главной странице сервиса
    Если я перешел на страницу "payments"
    То я буду на "login"
    И увижу "You must be logged in to access this page"

  Сценарий: Просмотр своих транзакции пользователем
    Допустим я зашел в сервис как "vlad@gmail.com/secret"
    И на главной странице сервиса
    Если я перешел на страницу "payments"
    То я увижу табличные данные в ".credits_table":
    |       Дата | Тип операции                      | Сумма     |
    | 01.02.2010 | Находка мп3 (модуль заказов)      | 0.10 руб. |
    | 02.02.2010 | Добавление новости (после апрува) | 0.04 руб. |
    И увижу табличные данные в ".debits_table":
    |       Дата | Тип операции   | Сумма     |
    | 03.02.2010 | Скачивание mp3 файла | 0.20 руб. |
    | 01.03.2010 | Скачивание mp3 файла | 0.40 руб. |
