# language: ru
Функционал: Поиск  по новостям и комментарии

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       | last_login_ip | id      | balance |
     | admin      | admin_user@gmail.com | secret   | true   | user, admin | 234.221.4.1   |  1      | 10      |
     | petr       | petr@gmail.com       | secret   | true   | user        | 234.221.4.2   |  2      | 20      |
     | anna       | anna@gmail.com       | secret   | true   | user        | 234.221.4.3   |  3      | 30      |


    И в сервисе есть следующие новости
    | header                  | meta         | text                          | description               |
    | Мы открыли новый сервис | meta новости | Теперь вы можете это и это... | Краткое описание конкурса |

    И я на странице"the homepage"
    И я выберу "search-in-news"
Сценарий: Поиск новостям
  И я введу в поле "search_string" значение "Мы открыли новый сервис"
  И я нажму "submit_search_form"
  То я увижу "Мы открыли новый сервис"

Сценарий: Поиск новостей
  И я введу в поле "search_string" значение ""
  И я нажму "submit_search_form"
  То я увижу "У вас пустой запрос"

Сценарий: Поиск новостей
  И я введу в поле "search_string" значение "флыралдфыоварлфыра"
  И я нажму "submit_search_form"
  То я увижу "Файл флыралдфыоварлфыра не найден в нашей базе, попробуйте запросить его в столе заказов"

