# language: ru
Функционал: Новости
Тестируем index, show и комментарии к новостям

Предыстория:

И в сервисе есть следующие новости
  | header         | meta   | text | description | created_at | state |
  | Мы открыли новый сервис meta | meta новости | Теперь вы можете это и это... | description | DataTime.now | active |
  | Мы новый сервис | meta новости | Теперь вы можете это и это... | description | 1.year.ago | active |

  И в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
  И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles | balance |
     | admin | admin_user@gmail.com | secret   | true   | admin |       0 |
     | vlad  | vlad@gmail.com       | secret   | true   | user  |       0 |

Сценарий: Тестируем мета теги
  Допустим я на "главной странице сервиса"
  То я перейду по ссылке "Мы открыли новый сервис"
  И я перейду по ссылке "meta"
  И я увижу "Мы открыли новый сервис meta"
  И я не увижу "Мы новый сервис"

Сценарий: Тестируем новости, со стороны пользователя
  Допустим я на "главной странице сервиса"
  То я перейду по ссылке "Мы открыли новый сервис"
  И я увижу "Теперь вы можете это и это..."

Сценарий: Комментирование новостей если я не зарегистророван
  Допустим я на "главной странице сервиса"
  И я перейду по ссылке "Мы открыли новый сервис"
  То я не увижу "Добавить комментарий"

Сценарий: Комментирование новостей если я зарегистророван
  Допустим я зашел в сервис как "admin_user@gmail.com/secret"
  И я на "главной странице сервиса"
  И я перейду по ссылке "Мы открыли новый сервис"
  И я введу в поле "comment[name]" значение "Моё имя"
  И я введу в поле "comment[email]" значение "asdasdas@ya.ru"
  И я введу в поле "comment[comment]" значение "Текст моего комментария"
  И нажму "Создать"
  То я увижу "Моё имя"
  И я увижу "asdasdas@ya.ru"
  И я увижу "Текст моего комментария"

