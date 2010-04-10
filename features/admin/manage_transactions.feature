# language: ru
Функционал: Просмотр транзакции администратором
  Админ должен иметь возможность просмотривать и разыскивать транзакции.

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

  Сценарий: Не должен пустить на страницу транзакции  если пользователь не администратор
    Допустим я зашел в сервис как "vlad@gmail.com/secret"
    Если я перешел на страницу "admin_transactions"
    То я увижу "Вы не имеете прав для просмотра данной страници."

  Сценарий: Доступ к транзакциям есть только у админстратора
    Допустим я зашел в сервис как "admin@gmail.com/secret"
    И есть следующие транзакции в сервиса:
 |id| date_transaction | user             | amount | type_transaction | kind_transaction | type_payment | status | gateway  |
 |1 |     01.02.2010   | vlad@gmail.com   |     30 | debit            | withdraw         | foreign      | open   | webmoney |
 |2 |     02.02.2010   | andrey@gmail.com |     20 | debit            | withdraw         | foreign      | open   | webmoney |
 |3 |     02.02.2010   |  liana@gmail.com |    15  | debit            | withdraw         |foreign       | open   | webmoney |
    Если я перешел на страницу "admin_transactions"
    То я буду на "admin_transactions"
    И увижу табличные данные в ".transactions_table":
    | Ид | Тип    |       Дата | Пользователь | Кошелек       | Статус        | Сумма   | Шлюз     |
    |  1 | Расход | 01.02.2010 | vlad         | Z222222222222 | Заказ выплаты | 30.00 $ | webmoney |
    |  2 | Расход | 02.02.2010 | andrey       | Z999999999999 | Заказ выплаты | 20.00 $ | webmoney |
    |  3 | Расход | 02.02.2010 | liana        | Z111111111111 | Заказ выплаты | 15.00 $ | webmoney |

