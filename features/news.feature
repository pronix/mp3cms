# language: ru
Функционал: Новости
Тестируем index и show

Предыстория:
  Допустим в сервисе есть следующие новости
  | header         | title    | meta                                                     | text            |
  | Сегодня сгорел дом  | Строим дом   | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
  | Завтра строим дом    | Строим          | Сгорел дом, дом сгорел, а сгорел ли дом, дома и участки, продажа домов | Ну сгорел и что теперь?  |
  | Ракета молот             | Ракета молот| Ракета молот  Ракета молот  Ракета молот  Ракета молот  Ракета молот                | Ракета не воробей!     |
  И я на странице "news"
Сценарий Тестируем новости, со стороны пользователя
  Допустим я увижу "Строим дом"
  И я увижу "Строим"
  И я увижу "Ракета молот"

  То я перейду по ссылке "Строим дом"
  И я увижу "Ну сгорел и что теперь?"

