# language: ru

@green
Функционал: Выплаты в админке
  Админ должен иметь возможность формировать файл массовых выплат для перечесление заработанных денег пользователем

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
    И в сервисе есть следующие пользователи:
     | login  | email            | password | active | roles | balance | webmoney_purse |
     | admin  | admin@gmail.com  | secret   | true   | admin |       0 | Z121212121212  |
     | vlad   | vlad@gmail.com   | secret   | true   | user  |      30 | Z222222222222  |
     | anna   | anna@gmail.com   | secret   | true   | user  |       3 | Z333333333333  |
     | ivan   | ivan@gmail.com   | secret   | true   | user  |       2 | Z555555555555  |
     | andrey | andrey@gmail.com | secret   | true   | user  |      20 | Z999999999999  |
     | liana  | liana@gmail.com  | secret   | true   | user  |      15 | Z111111111111  |


  Сценарий: Не должен пустить на выплаты если пользователь не администратор
    Допустим я зашел в сервис как "vlad@gmail.com/secret"
    Если я перешел на страницу "admin_payouts"
    То я увижу "Вы не имеете прав для просмотра данной страницы."

  Сценарий: Доступ к выплатам есть только у админстратора
    Допустим я зашел в сервис как "admin@gmail.com/secret"
    И есть следующие транзакции в сервиса:
     | id | date_transaction | user             | amount | type_transaction | kind_transaction | type_payment | status | gateway  |
     |  1 |       01.02.2010 | vlad@gmail.com   |     30 | debit            | withdraw         | foreign      | open   | webmoney |
     |  2 |       02.02.2010 | andrey@gmail.com |     20 | debit            | withdraw         | foreign      | open   | webmoney |
     |  3 |       02.02.2010 | liana@gmail.com  |     15 | debit            | withdraw         | foreign      | open   | webmoney |
    Если я перешел на страницу "admin_payouts"
    То я буду на "admin_payouts"
    И увижу табличные данные в ".withdraws_table":
     |   | Ид |       Дата | Пользователь | Статус      | Сумма   |
     |   |  1 | 01.02.2010 | vlad         | В обработке | 30.00 $ |
     |   |  2 | 02.02.2010 | andrey       | В обработке | 20.00 $ |
     |   |  3 | 02.02.2010 | liana        | В обработке | 15.00 $ |
    И увижу "Сформировать файл"
    И увижу "Завершить выплаты"
    И увижу "Выбрать все"
    И увижу "Снять выбор со всех"

  Сценарий: Формирование файла для массовых выплат.
    Допустим я зашел в сервис как "admin@gmail.com/secret"
    И в сервисе прописан шлюз "webmoney"
    И есть следующие транзакции в сервиса:
     | id | date_transaction | user             | amount | type_transaction | kind_transaction | type_payment | status | gateway  |
     |  1 |       01.02.2010 | vlad@gmail.com   |     30 | debit            | withdraw         | foreign      | open   | webmoney |
     |  2 |       02.02.2010 | andrey@gmail.com |     20 | debit            | withdraw         | foreign      | open   | webmoney |
     |  3 |       02.02.2010 | liana@gmail.com  |     15 | debit            | withdraw         | foreign      | open   | webmoney |
    И перешел на страницу "admin_payouts"
    Если я установлю флажок в "withdraw_ids[]"
    И нажму "generate_file"
    То мне должен отправиться сформированный файл

  Сценарий: Подтверждение что заявки на выплату выполнены
    Допустим я зашел в сервис как "admin@gmail.com/secret"
    И есть следующие транзакции в сервиса:
     | id | date_transaction | user             | amount | type_transaction | kind_transaction | type_payment | status | gateway  |
     |  1 |       01.02.2010 | vlad@gmail.com   |     30 | debit            | withdraw         | foreign      | open   | webmoney |
     |  2 |       02.02.2010 | andrey@gmail.com |     20 | debit            | withdraw         | foreign      | open   | webmoney |
     |  3 |       02.02.2010 | liana@gmail.com  |     15 | debit            | withdraw         | foreign      | open   | webmoney |
    И перешел на страницу "admin_payouts"
    Если я установлю флажок в "withdraw_ids[]"
    И нажму "success_claim"
    То я увижу "Заявки на выплату завершены."

