# language: ru
 Функционал: Управление серверами хранения мп3
   Администратор должен иметь возможность добавлять сервера, назначать сервер хранения мп3

   Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator"
    И в сервисе есть следующие пользователи:
     | login      | email                | password | active | roles       |
     | admin_user | admin_user@gmail.com | secret   | true   | user, admin |
     | petr       | petr@gmail.com       | secret   | true   | user        |
     | anna       | anna@gmail.com       | secret   | true   | user        |
     Допустим зашел в сервис как "admin_user@gmail.com/secret"
     И я на странице управление серверами

  Сценарий: Проверка валидации
    Допустим я перейду по ссылке "Добавить новый сервер"
    Если я нажму "Создать новый сервер"
      То я увижу "Название сервера не может быть пустым"
      И я увижу "Ip не может быть пустым"
      И я увижу "Доменное имя не может быть пустым"

  Сценарий: Создание первого сервера и проверки его статуса как основного хранилеща mp3
    Допустим я перейду по ссылке "Добавить новый сервер"
    И я введу в поле "satellite[name]" значение "Ястреб"
    И я введу в поле "satellite[ip]" значение "127.0.0.1"
    И я введу в поле "satellite[domainname]" значение "www.ya.ru"
    И я введу в поле "satellite[community]" значение "community"
    И я нажму "Создать новый сервер"
    И я увижу "Новый сервер был привязан к сайту"
    И я увижу "Основной сервер хранения"

  Сценарий: Назначение нвого сервера хранения
    Допустим к системе привязанны следующие сервера хранения
    | id | name | ip | domainname | description | master |
    | 1 | Ястреб 1 | 127.0.0.1 | www.yandex.ru | satellite 1 | true |
    | 2 | Ястреб 2 | 127.0.0.2 | www.ya.ru | satellite 2 | false |
    И я на странице управление серверами
    И я выберу "server_2"
    И я нажму "Выбрать новый сервер"
    То я увижу "Выбранный вами сервер уже является основным сервером хранения mp3"
    Если я выберу "server_1"
    И я нажму "Выбрать новый сервер"
    То я увижу "Сервер хранения mp3 был изменён"

  Сценарий: Удаление сервера
    Допустим к системе привязанны следующие сервера хранения
    | id | name | ip | domainname | description | master |
    | 1 | Ястреб 1 | 127.0.0.1 | www.yandex.ru | satellite 1 | true |
    | 2 | Ястреб 2 | 127.0.0.2 | www.ya.ru | satellite 2 | false |
    И я на странице управление серверами
    И я перейду по ссылке "delete_server_2"
    То я увижу "Прежде чем удалить сервер хранения mp3, перенесите его обязанности на другой сервер"
    Если я перейду по ссылке "delete_server_1"
    То я увижу "Сервер был успешно удалён"

  Сценарий: Редактирования сервера
    Допустим к системе привязанны следующие сервера хранения
    | id | name | ip | domainname | description | master |
    | 1 | Ястреб 1 | 127.0.0.1 | www.yandex.ru | satellite 1 | true |
    И я на странице управление серверами
    И я перейду по ссылке "Редактировать"
    И я введу в поле "satellite[name]" значение "Кролик 1"
    И я введу в поле "satellite[ip]" значение "222.111.222.123"
    И я введу в поле "satellite[domainname]" значение "www.ya.ru"
    И я введу в поле "satellite[description]" значение "rabbit 1"
    И я нажму "Сохранить"
    То я увижу "Параметры сервера были изменены"

