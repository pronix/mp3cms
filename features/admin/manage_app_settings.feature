# language: ru
Функционал: Параметры приложения, которые администратор можеть менять
  Админ должен иметь возможность изменять параметры приложения влияющие на вывод рейтингов

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
    И в сервисе есть следующие пользователи:
     | login  | email            | password | active | roles | balance | webmoney_purse |
     | admin  | admin@gmail.com  | secret   | true   | admin |       0 | Z121212121212  |
     | vlad   | vlad@gmail.com   | secret   | true   | user  |      30 | Z222222222222  |
    И в сервисе прописаны изменяемые параметры по умолчанию

    Сценарий: Просмотр списка парметров не администратором
      Допустим я зашел в сервис как "vlad@gmail.com/secret"
      Если я перешел на страницу "admin_settings"
      То я увижу "Sorry, you are not allowed to access that page."

    Сценарий: Просмотр списка параметров администратором
      Допустим я зашел в сервис как "admin@gmail.com/secret"
      Если я перешел на страницу "admin_settings"
      То я увижу табличные данные в ".settings_table":
       | Параметр                               | Значение |               |
       | Сколько пользователей выводить в топе  |        7 | Редактировать |
       | Заработанная сумма за последние Х дней |        7 | Редактировать |
       | Добавлено файлов за Х дней             |        7 | Редактировать |
       | Сколько треков выводить в топе         |        7 | Редактировать |
       | Скачано файлов за Х дней               |        7 | Редактировать |

    Сценарий: Редактирование параметров
      Допустим я зашел в сервис как "admin@gmail.com/secret"
      Если я перешел на страницу "admin_settings"
      То я увижу табличные данные в ".settings_table":
       | Параметр                               | Значение |               |
       | Сколько пользователей выводить в топе  |        7 | Редактировать |
       | Заработанная сумма за последние Х дней |        7 | Редактировать |
       | Добавлено файлов за Х дней             |        7 | Редактировать |
       | Сколько треков выводить в топе         |        7 | Редактировать |
       | Скачано файлов за Х дней               |        7 | Редактировать |
      Если я нажму "Редактировать" для "2" позиции в ".settings_table>tr"
      И введу в поле "app_setting[value]" значение "14"
      И нажму "Сохранить"
      То я увижу "Параметр обновлен"
      И я увижу табличные данные в ".settings_table":
       | Параметр                               | Значение |               |
       | Сколько пользователей выводить в топе  |        7 | Редактировать |
       | Добавлено файлов за Х дней             |        7 | Редактировать |
       | Сколько треков выводить в топе         |        7 | Редактировать |
       | Скачано файлов за Х дней               |        7 | Редактировать |
       | Заработанная сумма за последние Х дней |       14 | Редактировать |
