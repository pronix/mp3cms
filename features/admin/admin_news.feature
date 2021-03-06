# language: ru
Функционал: Управление новостями в административной панели через пункт меню "Категории (новостей)"

  Предыстория:
  Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
    Допустим в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       | last_login_ip | id      | balance |
     | admin      | admin_user@gmail.com | secret   | true   | user, admin | 234.221.4.1   |  1      | 10      |


И в сервисе есть следующие новости
  | header         | meta   | text | description | created_at | state |
  | Мы открыли новый сервис | meta новости | Теперь вы можете это и это... | description | DataTime.now | active |

  И я зашел в сервис как "admin_user@gmail.com/secret"

Сценарий: Удаление новости из раздела Новости
  Допустим я на странице "admin_news_items"
  То я увижу "Мы открыли новый сервис"
  И я перейду по ссылке "Удалить"
  То я не увижу "Мы открыли новый сервис"

Сценарий: Создание новостей из раздела Новости
  Допустим я на странице  "admin_news_items"
  И я перейду по ссылке "Добавить новость"

Сценарий: Добавление новой новости пустыми полями
  Допустим  я на "admin_news_items"
  И я перейду по ссылке "Добавить новость"
  Если я введу в поле "news_item[header]" значение ""
  И я введу в поле "news_item[meta]" значение ""
  И я введу в поле "news_item[text]" значение ""
  И я введу в поле "news_item[description]" значение ""
  И я нажму "Создать"
  То я увижу "не может быть пустым"

Сценарий: Добавление новой новости подгрузка фотографий и удаление этих фотографий
  Допустим  я на "admin_news_items"
  И я перейду по ссылке "Удалить"
  И я перейду по ссылке "Добавить новость"
  И я введу в поле "news_item[header]" значение "news_header"
  И я введу в поле "news_item[meta]" значение "meta"
  И я введу в поле "news_item[text]" значение "text"
  И я введу в поле "news_item[description]" значение "description"
  И я добавлю в поле "newsimage_0_photo" фаил "vetton_ru_1023.jpg"
  И я нажму "Создать"
  То я перейду по ссылке "Редактировать"
  И я перейду по ссылке "Удалить картинку"

