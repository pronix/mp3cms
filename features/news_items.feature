# language: ru
Функционал: Новости
Тестируем index, show и комментарии к новостям

Предыстория:
Допустим в сервисе есть следующие категории новостей
  | id | name |
  | 1 | cat 1 |
  | 2 | cat 2 |

И в категории "cat 1" есть следующие новости
  | header         | meta   | text | description |
  | Мы открыли новый сервис | meta новости | Теперь вы можете это и это... | description |

  И в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
  И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles | balance |
     | admin | admin_user@gmail.com | secret   | true   | admin |       0 |
     | vlad  | vlad@gmail.com       | secret   | true   | user  |       0 |

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
  Допустим я на "главной странице сервиса"
  И я перейду по ссылке "Мы открыли новый сервис"
  И я введу в поле "comment[title]" значение "Заголовок моего комментария"
  И я введу в поле "comment[comment]" значение "Текст моего комментария"
  И нажму "Создать"
  То я увижу "Заголовок моего комментария"
  И я увижу "Текст моего комментария"

Сценарий: Тестируем сортировку новостей
  Допустим я на "главной странице сервиса"
  То я перейду по ссылке "Новости"
  И я увижу "Теперь вы можете это и это..."

