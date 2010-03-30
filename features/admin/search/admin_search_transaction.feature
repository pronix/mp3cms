# language: ru
Функционал: Поиск в административной панели по трекам
Поиск по исполнителю, названию, айди, битрейту, весу файла (больше, меньше или равно), по пользователю добавившему файл.

Предыстория:
  Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
  И в сервисе есть следующие пользователи:
  | id | login | email                | password | active | roles       | balance |
  |  1 | admin | admin_user@gmail.com | secret   | true   | user, admin |      10 |
  |  2 | petr  | petr@gmail.com       | secret   | true   | user        |      20 |
  |  3 | anna  | anna@gmail.com       | secret   | true   | user        |      30 |

  И the following profits:
  | name                                      | code           | amount | percentage | type_transaction |
  | Нарезка файла (после клика на скачивание) | assorted_track |   0.01 |          0 | debit            |

  И в сервисе прошли следующие транзакции для пользователя "petr"
  | date_transaction | amount | kind_transaction | type_payment | type_transaction | gateway    |
  |       2005:02:02 |  10.66 | order_track      |            1 |                1 | webmoney   |
  |       2007:02:02 |   5.55 | order_track      |            2 |                2 | mobilecent |

  И в сервисе прошли следующие транзакции для пользователя "anna"
  | date_transaction | amount | kind_transaction | type_payment | type_transaction | gateway    |
  |       2008:02:02 |  15.66 | order_track      |            1 |                1 | webmoney   |
  |       2009:02:02 |  20.55 | order_track      |            2 |                2 | mobilecent |

  И обновляем индексы Sphinx
  И я зашел в сервис как "admin_user@gmail.com/secret"
  И я на странице "поиск транзакции в админке"

Сценарий: Нулевой запрос
  Допустим я нажму "search_transaction" в "#form_transaction"
  То я увижу "По вашему запросу ничего не найденно"

Сценарий: Поиск по типу транзакции "Доход"
  Допустим я выберу "attribute_type_transaction" в "#form_transaction"
  И я выберу "attribute_type_transaction" в "#form_transaction"
  И я выберу "Доход" из "transaction[select_type_transaction]"
  И я выберу "1 января 2005" как дату "transaction_start_transaction"
  И я выберу "1 января 2010" как дату "transaction_end_transaction"
  И я нажму "search_transaction" в "#form_transaction"
  И я увижу "02.02.2005"
  И я увижу "02.02.2008"

Сценарий: Поиск по типу транзакции "Расход"
  Допустим я выберу "attribute_type_transaction" в "#form_transaction"
  И я выберу "attribute_type_transaction" в "#form_transaction"
  И я выберу "Расход" из "transaction[select_type_transaction]"
  И я выберу "1 января 2005" как дату "transaction_start_transaction"
  И я выберу "1 января 2010" как дату "transaction_end_transaction"
  И я нажму "search_transaction" в "#form_transaction"
  И я увижу "02.02.2007"
  И я увижу "02.02.2009"

Сценарий: Поиск по кошельку с большым значением
  Допустим я выберу "1 января 2005" как дату "transaction_start_transaction"
  И я выберу "1 января 2010" как дату "transaction_end_transaction"
  И я выберу "attribute_webmoney_purs" в "#form_transaction"
  И я выберу "webmoney_purs_more" в "#form_transaction"
  И я введу в поле "q" значение "10.65"
  И я нажму "search_transaction" в "#form_transaction"
  И я увижу "10.66"
  И я увижу "15.66"
  И я увижу "20.55"
  И я не увижу "5.55"

Сценарий: Поиск по кошельку с меньшим значением
  Допустим я выберу "1 января 2005" как дату "transaction_start_transaction"
  И я выберу "1 января 2010" как дату "transaction_end_transaction"
  И я выберу "attribute_webmoney_purs" в "#form_transaction"
  И я выберу "webmoney_purs_less" в "#form_transaction"
  И я введу в поле "q" значение "15.67"
  И я нажму "search_transaction" в "#form_transaction"
  И я увижу "10.66"
  И я увижу "15.66"
  И я увижу "5.55"
  И я не увижу "20.55"

Сценарий: Поиск по кошельку с равным значением
  Допустим я выберу "1 января 2005" как дату "transaction_start_transaction"
  И я выберу "1 января 2010" как дату "transaction_end_transaction"
  И я выберу "attribute_webmoney_purs" в "#form_transaction"
  И я выберу "webmoney_purs_well" в "#form_transaction"
  И я введу в поле "q" значение "15.66"
  И я нажму "search_transaction" в "#form_transaction"
  И я увижу "15.66"
  И я не увижу "10.66"
  И я не увижу "5.55"
  И я не увижу "20.55"

Сценарий: Поиск способу оплаты webmoney
  Допустим я выберу "1 января 2005" как дату "transaction_start_transaction"
  И я выберу "1 января 2010" как дату "transaction_end_transaction"
  И я выберу "attribute_type_payment" в "#form_transaction"
  И я выберу "webmoney" из "transaction_select_type_payment"
  И я нажму "search_transaction" в "#form_transaction"
  И я увижу "02.02.2005"
  И я увижу "02.02.2008"
  И я не увижу "02.02.2007"
  И я не увижу "02.02.2009"

Сценарий: Поиск способу оплаты sms
  Допустим я выберу "1 января 2005" как дату "transaction_start_transaction"
  И я выберу "1 января 2010" как дату "transaction_end_transaction"
  И я выберу "attribute_type_payment" в "#form_transaction"
  И я выберу "sms" из "transaction_select_type_payment"
  И я нажму "search_transaction" в "#form_transaction"
  И я не увижу "02.02.2005"
  И я не увижу "02.02.2008"
  И я увижу "02.02.2007"
  И я увижу "02.02.2009"

Сценарий: Поиск по пользователю
  Допустим я выберу "1 января 2005" как дату "transaction_start_transaction"
  И я выберу "1 января 2010" как дату "transaction_end_transaction"
  И я выберу "attribute_login" в "#form_transaction"
  И я введу в поле "q" значение "petr"
  И я нажму "search_transaction" в "#form_transaction"
  И я увижу "petr"
  И я не увижу "anna"

