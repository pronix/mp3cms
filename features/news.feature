# language: ru
Функционал: Новости
Тестируем index и show

Предыстория:
  Допустим в сервисе есть следующие новости
  | header         | meta                                                     | text                |
  | Сегодня сгорел дом  | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |

Сценарий Тестируем новости, со стороны пользователя
  И я на странице "news"
  Допустим я увижу "Строим дом"
  И я увижу "Строим"
  И я увижу "Ракета молот"

  То я перейду по ссылке "Строим дом"
  И я увижу "Ну сгорел и что теперь?"


Сценарий: Просмотор новости из админки
  Допустим я на странице "admin_news_url"
  То я увижу "Строим дом"
  Если я перейду по ссылке "Строим дом"
  То я увижу "Строим дом"
  И я увижу "Ну сгорел и что теперь?"

Сценарий: Удаление новости из админки
  Допустим я на странице "admin_news_url"
  То я увижу "Строим дом"
  Если я перейду по ссылке "Delete"
  То я не увижу "Строим дом"

Сценарий: Редактирование новости
  Допустим я на странице "admin_news_url"
  То я увижу "Строим дом"
  Если я перейду по ссылке "Edit"
  То я запишу в поле "news[header]" значение "Новость номер раз!"
  И я запишу в поле "news[text]" значение "Текст новости"
  И я запишу в поле "news[meta]" значение "meta новости"

  Если я нажму "update"
  То я увижу "Новость обнавленна"
  И я увижу "Новость номер раз!"

  Если я перейду по ссылке "Show"
  То я увижу "Текст новости"

Сценарий: Добавление новости
  Допустим новостей нет

