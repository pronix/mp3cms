# language: ru
 Функционал: Транзакции пользователя.
   Авторизованый пользователь может просмотривать  свои транзакции по доходам и расходам,
   также пополнять свой баланс и подавать заявку на вывод денег.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator(id:3)"
     И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles       | balance | webmoney_purse |
     | admin | admin_user@gmail.com | secret   | true   | user, admin |       0 |                |
     | vlad  | vlad@gmail.com       | secret   | true   | user        |      11 | Z121212121212  |
     | inna  | inna@gmail.com       | secret   | true   | user        |       9 |                |

     И в сервисе записана стоимости по умолчанию
     И есть следующие транзакции в сервиса:
    | date_transaction | user           | amount | type_transaction | kind_transaction | type_payment | status  |
    |       01.02.2010 | vlad@gmail.com |    0.1 | credit           | find_track       | internal     | success |
    |       02.02.2010 | vlad@gmail.com |   0.02 | credit           | add_news         | internal     | success |
    |       02.02.2010 | vlad@gmail.com |   0.02 | credit           | add_news         | internal     | success |
    |       03.02.2010 | vlad@gmail.com |    0.2 | debit            | download_track   | internal     | success |
    |       01.03.2010 | vlad@gmail.com |    0.2 | debit            | download_track   | internal     | success |
    |       01.03.2010 | vlad@gmail.com |    0.2 | debit            | download_track   | internal     | success |
    |       01.03.2010 | vlad@gmail.com |    0.3 | debit            | order_track      | internal     | success |
    И прописаны параметры платежного шлюза "webmoney"

  Сценарий: Попытка просмотра не авторизованным пользователем
    Допустим я на главной странице сервиса
    Если я перешел на страницу "payments"
    То я буду на "login"
    И увижу "Вы должны быть авторизорованны, для доступа к этой странице"

  Сценарий: Просмотр своих транзакции пользователем
    Допустим я зашел в сервис как "vlad@gmail.com/secret"
    И на главной странице сервиса
    Если я перешел на страницу "payments"
    И я перейду по ссылке "История"
    То я увижу табличные данные в ".credits_table":
    |       Дата | Тип операции                      | Сумма  |
    | 01.02.2010 | Находка мп3 (модуль заказов)      | 0.10 $ |
    | 02.02.2010 | Добавление новости (после апрува) | 0.04 $ |
    И увижу табличные данные в ".debits_table":
    |       Дата | Тип операции         | Сумма  |
    | 03.02.2010 | Скачивание mp3 файла | 0.20 $ |
    | 01.03.2010 | Скачивание mp3 файла | 0.40 $ |
    |            | Заказ mp3            | 0.30 $ |
    И увижу "Ваш баланс: 11.00 $"

  Сценарий: Скрытие ссылки на вывод денег, на странице транзакции пользователем если баланс меньше минимума
    Допустим в сервисе записана стоимости по умолчанию
    И зашел в сервис как "inna@gmail.com/secret"
    И на главной странице сервиса
    Если я перешел на страницу "payments"
    То я не увижу ссылку "Заказ выплаты"

  Сценарий: Вывод ссылки на вывод денег, на странице транзакции пользователем если позволяет баланс
    Допустим в сервисе записана стоимости по умолчанию
    И зашел в сервис как "vlad@gmail.com/secret"
    И на главной странице сервиса
    Если я перешел на страницу "payments"
    То я увижу ссылку "Заказ выплаты"

  Сценарий: Пополнение баланса пользователем
    Допустим в сервисе записана стоимости по умолчанию
    И зашел в сервис как "vlad@gmail.com/secret"
    И на главной странице сервиса
    Если я перешел на страницу "payments"
    И перейду по ссылке "webmoney"
    То я увижу поле "pay[amount]"
    Если я введу в поле "pay[amount]" значение "3"
    И нажму "Продолжить"
    То я увижу "Сумма к оплате 3.00"
    И у пользователя "vlad@gmail.com" должна быть открытая транзакция
    И увижу форму отправки на оплату через webmoney


  Сценарий: Создание заявки на выплату денег.
    Допустим в сервисе записана стоимости по умолчанию
    И транзакции в сервисе еще нет
    И зашел в сервис как "vlad@gmail.com/secret"
    И на главной странице сервиса
    Если я перешел на страницу "payments"
    И перейду по ссылке "Заказ выплаты"
    То я увижу поле "withdraw[amount]"
    Если я введу в поле "withdraw[amount]" значение "10"
    И нажму "Продолжить"
    То у пользователя "vlad@gmail.com" должна быть открытая заявка на вывод денег
    То я увижу "Заявка № "




