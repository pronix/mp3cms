# language: ru
Функционал: Поиск в административной панели по новостям
По айди, названию.

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin(id:1;admin:true), user(id:2), moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       | last_login_ip | id      | balance |
     | admin      | admin_user@gmail.com | secret   | true   | user, admin | 234.221.4.1   |  1      | 10      |

  И в сервисе есть следующие категории новостей
  | id | name |
  | 1 | cat 1 |
  | 2 | cat 2 |

  И в категории "cat 1" есть следующие новости
  | id | header |  meta | text | description |
  | 1  | Мы открыли новый сервис | meta новости | Теперь вы можете это и это... | news description |
  | 2  | Внимание конкурс | meta новости | Каждому 10 клиенту, подарок | Краткое описание конкурса |
  | 3  | Доступен новый формат трекв | meta новости | Теперь вы можете это и это... | Краткое описание новости |


  И в категории "cat 2" есть следующие новости
  | id | header         | meta  | text | description |
  | 4  | Открыт новый сервис на проекте  | Вы можете заработать | Зарабатывайте вместе с нами  | Новый сервис рулит |
  | 5  | Топ10 нашего сайта    | Признан самым актуальным | Независимый источник признал наш Топ10 | Top10 рулит |
  | 6  | 100 топовый треков прошлого года | Что признал народ | Статистика скаченных треков за прошлый год | Статистика дескрипшен |

  И обновляем индексы Sphinx
  И я зашел в сервис как "admin_user@gmail.com/secret"
  И я на странице "поиск в админке"

Сценарий: Поиск по новостям в админке с пустым запросом
  И я введу в поле "search_news" значение ""
  И я выберу "attribute_everywhere" в "#form_news_item"
  И я нажму "Найти" в "#form_news_item"
  То я увижу "По вашему запросу ничего не найденно"

Сценарий: Поиск по новостям с нулевум результатом
  И я введу в поле "search_news" значение "kjahsdgfjkahsdgf"
  И я выберу "attribute_everywhere" в "#form_news_item"
  И я нажму "Найти" в "#form_news_item"
  То я увижу "По вашему запросу ничего не найденно"

Сценарий: Поиск с атрибутом ВЕЗДЕ
  И я введу в поле "search_news" значение "Топ10 нашего сайта"
  И я выберу "attribute_everywhere" в "#form_news_item"
  И я нажму "Найти" в "#form_news_item"
  То я увижу "Топ10 нашего сайта"

Сценарий: Поиск новости с атрибутом ПО ID и проверка существований ссылок на удаление и редактирование найденной новости
  И я введу в поле "search_news" значение "4"
  И я выберу "attribute_id" в "#form_news_item"
  И я нажму "Найти" в "#form_news_item"
  То я увижу "Открыт новый сервис на проекте"
  И я увижу "Редактировать"
  И я увижу "Удалить"

