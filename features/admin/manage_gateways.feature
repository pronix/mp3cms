# language: ru
Функционал: Настройка Webmoney
  Админ должен иметь возможность редактироваться параметры webmoney

  Предыстория:
  Допустим в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
  И в сервисе есть следующие пользователи:
     | login | email                | password | active | roles | balance |
     | admin | admin_user@gmail.com | secret   | true   | admin |       0 |
     | vlad  | vlad@gmail.com       | secret   | true   | user  |       0 |


  Сценарий: Доступ не админу должен быть закрыт к настройкам webmoney
    Допустим я зашел в сервис как "vlad@gmail.com/secret"
    Если я перешел на страницу "admin_gateways"
    То я увижу "Sorry, you are not allowed to access that page."

  Сценарий: Просмотр списка платежных шлюзов
    Допустим в сервисе прописан шлюз "webmoney"
    И я зашел в сервис как "admin_user@gmail.com/secret"
    Если я перешел на страницу "admin_gateways"
    То я увижу табличные данные в ".gateways_table":
    | Название | Включен | Действия      |
    | Webmoney | Да      | Редактировать |

  Сценарий: Редактирование параметров Webmoney
    Допустим в сервисе прописан шлюз "webmoney"
    И я зашел в сервис как "admin_user@gmail.com/secret"
    Если я перешел на страницу "admin_gateways"
    И перейду по ссылке "Edit webmoney"
    И введу в поле "gateway[wmid]" значение "329080303197"
    И нажму "Обновить данные"
    То я увижу "Webmoney данные обновлены."


