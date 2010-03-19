# language: ru
Функционал: Выплаты в админке
  Админ должен иметь возможность формировать файл массовых выплат для перечесление заработанных денег пользователем

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
    И в сервисе есть следующие пользователи:
     | login  | email                | password | active | roles | balance |
     | admin  | admin@gmail.com      | secret   | true   | admin |       0 |
     | vlad   | vlad@gmail.com       | secret   | true   | user  |      30 |
     | anna   | anna@gmail.com       | secret   | true   | user  |       3 |
     | ivan   | ivan@gmail.com       | secret   | true   | user  |       2 |
     | andrey | andrey@gmail.com     | secret   | true   | user  |      20 |
     | liana  | liana@gmail.com      | secret   | true   | user  |      15 |


  Сценарий: Не должен пустить на выплаты если пользователь не администратор
    Допустим я зашел в сервис как "vlad@gmail.com/secret"
    Если я перешел на страницу "admin_payouts"
    То я увижу "Sorry, you are not allowed to access that page."

  Сценарий: Доступ к выплатам есть только у админстратора
    Допустим я зашел в сервис как "admin@gmail.com/secret"
     И есть следующие транзакции в сервиса:
 | date_transaction | user             | amount | type_transaction | kind_transaction | type_payment | status | gateway  |
 |       01.02.2010 | vlad@gmail.com   |     30 | debit            | withdraw         | foreign      | open   | webmoney |
 |       02.02.2010 | andrey@gmail.com |     20 | debit            | withdraw         | foreign      | open   | webmoney |
 |       02.02.2010 | liana@gmail.com  |     15 | debit            | withdraw         | foreign      | open   | webmoney |
    Если я перешел на страницу "admin_payouts"
    То я буду на "admin_payouts"
    И увижу табличные данные в ".withdraws_table":
     |   |       Дата | Пользователь | Статус | Сумма      |
     |   | 01.02.2010 | vlad         | В обработке | 30.00 руб. |
     |   | 02.02.2010 | andrey       | В обработке | 20.00 руб. |
     |   | 02.02.2010 | liana        | В обработке | 15.00 руб. |
    И увижу "Сформировать файл"
    И увижу "Завершить выплаты"
    И увижу "Выбрать все"
    И увижу "Снять выбор со всех"

  Сценарий: Формирование файла для массовых выплат.
    Допустим я зашел в сервис как "admin@gmail.com/secret"
     И есть следующие транзакции в сервиса:
 | date_transaction | user             | amount | type_transaction | kind_transaction | type_payment | status | gateway  |
 |       01.02.2010 | vlad@gmail.com   |     30 | debit            | withdraw         | foreign      | open   | webmoney |
 |       02.02.2010 | andrey@gmail.com |     20 | debit            | withdraw         | foreign      | open   | webmoney |
 |       02.02.2010 | liana@gmail.com  |     15 | debit            | withdraw         | foreign      | open   | webmoney |
     И перешел на страницу "admin_payouts"
     Если я установлю флажок в "withdraw_ids[]"
     И нажму "generate_file"

  Сценарий: Подтверждение что заявки на выплату выполнены
    Допустим я зашел в сервис как "admin@gmail.com/secret"
     И есть следующие транзакции в сервиса:
 | date_transaction | user             | amount | type_transaction | kind_transaction | type_payment | status | gateway  |
 |       01.02.2010 | vlad@gmail.com   |     30 | debit            | withdraw         | foreign      | open   | webmoney |
 |       02.02.2010 | andrey@gmail.com |     20 | debit            | withdraw         | foreign      | open   | webmoney |
 |       02.02.2010 | liana@gmail.com  |     15 | debit            | withdraw         | foreign      | open   | webmoney |
     И перешел на страницу "admin_payouts"
     Если я установлю флажок в "withdraw_ids[]"
     И нажму "success_claim"

