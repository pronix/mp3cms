# language: ru
Функционал: Поиск в административной панели
  Админи могут искать по новостям, мп3, пользователям, плейлистам, транзакциям

  Предыстория:
  Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
    Допустим в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       | last_login_ip | id      | balance |
     | admin      | admin_user@gmail.com | secret   | true   | user, admin | 234.221.4.1   |  1      | 10      |


  И в сервисе есть следующие категории новостей
  | id | name |
  | 1 | cat 1 |
  | 2 | cat 2 |
  | 3 | cat 3 |

  И я зашел в сервис как "admin_user@gmail.com/secret"
  И я на странице "категории новостей"

Сценарий: Добавление новой новости пустыми полями
  Допустим я перейду по ссылке "cat 1"
  И я перейду по ссылке "Создать новость"
  Если я введу в поле "news_item[header]" значение ""
  И я введу в поле "news_item[meta]" значение ""
  И я введу в поле "news_item[text]" значение ""
  И я нажму "Create Newsitem"
  То я увижу "Models, news item, attributes, text, blank"

Сценарий: Добавление новой новости пустыми полями и удаление новости
  Допустим я перейду по ссылке "cat 1"
  И я перейду по ссылке "Создать новость"
  Если я введу в поле "news_item[header]" значение "news_header"
  И я введу в поле "news_item[meta]" значение "meta"
  И я введу в поле "news_item[text]" значение "text"
  И я выберу "cat 1" из "news_item_news_category_ids"
  И я выберу "cat 2" из "news_item_news_category_ids"
  И я выберу "cat 3" из "news_item_news_category_ids"
  И я нажму "Create Newsitem"
  То я должен быть на странице "категории новостей"
  И я перейду по ссылке "cat 1"
  И я увижу "news_header"

  Допустим я на странице "категории новостей"
  И я перейду по ссылке "cat 2"
  И я увижу "news_header"

  И я перейду по ссылке "Удалить"
  То я не увижу "news_header"

