# language: ru
Функционал: Новости
Тестируем index и show

Предыстория:
Допустим в сервисе есть следующие категории новостей
  | id | name |
  | 1 | cat 1 |
  | 2 | cat 2 |

Допустим в категории "cat 1" есть следующие новости
  | header         | meta                                                     | text                |
  | Сегодня сгорел дом  | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |

Сценарий: Тестируем новости, со стороны пользователя
  И я на странице "news_url"
  Допустим я увижу "Сегодня сгорел дом"

  То я перейду по ссылке "Сегодня сгорел дом"
  И я увижу "Ну сгорел и что теперь?"

