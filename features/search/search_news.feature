# language: ru
Функционал: Поиск  по новостям и комментарии

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       | last_login_ip | id      | balance |
     | admin      | admin_user@gmail.com | secret   | true   | user, admin | 234.221.4.1   |  1      | 10      |
     | petr       | petr@gmail.com       | secret   | true   | user        | 234.221.4.2   |  2      | 20      |
     | anna       | anna@gmail.com       | secret   | true   | user        | 234.221.4.3   |  3      | 30      |

Допустим в сервисе есть следующие категории новостей
  | id | name |
  | 1 | cat 1 |
  | 2 | cat 2 |

И в категории "cat 1" есть следующие новости
  | header         | meta   | text  | description |
  | Мы открыли новый сервис | meta новости | Теперь вы можете это и это... | description |

    Допустим я на странице"the homepage"
    И я выберу "search-in-news"
Сценарий: Поиск новостям
  И я введу в поле "search_string" значение "Мы открыли новый сервис"
  И я нажму "submit_search_form"
  То я увижу "Мы открыли новый сервис"

Сценарий: Поиск а админке плейлиста с нулевым запросом
  И я введу в поле "search_string" значение ""
  И я нажму "submit_search_form"
  То я увижу "По вашему запросу ничего не найденно"

Сценарий: Поиск а админке плейлиста с нулевым результатом
  И я введу в поле "search_string" значение "флыралдфыоварлфыра"
  И я нажму "submit_search_form"
  То я увижу "По вашему запросу ничего не найденно"

