# language: ru
Функционал: Настройка стоимости действий пользователя
  Администратор должен иметь возможность редактировать стоимость действий пользователя

  Предыстория:
  Допустим в сервисе записана стоимости по умолчанию
  И в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
  И в сервисе есть следующие пользователи:
     | id | login | email                | password | active | roles | balance |
     |  1 | admin | admin_user@gmail.com | secret   | true   | admin |       0 |
     |  2 | ivan  | ivan@gmail.com       | secret   | true   | user  |       5 |
     |  3 | lia   | lia@gmail.com        | secret   | true   | user  |       5 |


# credit_find_track - пополнение баланса за выполнение задания в столе заказов 0.01
# credit_add_news - пополнение баланса за дополнение путевой новости 0.02
# credit_upload_track - - пополнение баланса за загрузку нормального трека 0.1
  Сценарий: Начиление за выполнение задания в столе заказов
    Допустим пользователю "ivan@gmail.com" делаем начисление "credit_find_track"
    То баланс пользователя "ivan@gmail.com" равен "5.01"

  Сценарий: Начиление за добовление путевой новости
    Допустим пользователю "ivan@gmail.com" делаем начисление "credit_add_news"
    То баланс пользователя "ivan@gmail.com" равен "5.02"

  Сценарий: Начиление за загрузку нормального трека
    Допустим пользователю "ivan@gmail.com" делаем начисление "credit_upload_track"
    То баланс пользователя "ivan@gmail.com" равен "5.1"

# Генерируеме метода для списанияс баланса пользователя внутренними платежами:
# debit_assorted_track  -  списание с баланса пользователя за нарезку трека "assorted_track"  0.01
# debit_download_track  -  списание с баланса пользователя за скачивание трека "download_track" 0.02
# debit_order_track     -  списание с баланса пользователя за размещение заказа в столе заказов "order_track" 0.02
  Сценарий: Списание  за нарезку трека
    Допустим пользователю "ivan@gmail.com" делаем начисление "debit_assorted_track"
    То баланс пользователя "ivan@gmail.com" равен "4.99"

  Сценарий: Списание  за скачивание трека
    Допустим пользователю "ivan@gmail.com" делаем начисление "debit_download_track"
    То баланс пользователя "ivan@gmail.com" равен "4.98"

  Сценарий: Списание  за  размещение заказа в столе заказов
    Допустим пользователю "ivan@gmail.com" делаем начисление "debit_order_track"
    То баланс пользователя "ivan@gmail.com" равен "4.98"

  Сценарий: Начисление % рефералу ( "referrer_bonus" 40%)
    Допустим пользователь "ivan@gmail.com" закреплен за "lia@gmail.com"
    И пользователю "ivan@gmail.com" делаем начисление "debit_download_track"
    То баланс пользователя "ivan@gmail.com" равен "4.98"
    И  баланс пользователя "lia@gmail.com" равен "5.008"


