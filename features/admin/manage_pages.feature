# language: ru

@green
Функционал: Управление статическими страницами
  Админ должен иметь возможность редактироваться статичесткие страницы

  Предыстория:
    Допустим в сервисе есть следующие роли пользователей "admin, user, moderator, custom_add_mp3"
    И в сервисе есть следующие пользователи:
      | login | email                | password | active | roles | balance |
      | admin | admin_user@gmail.com | secret   | true   | admin |       0 |
      | vlad  | vlad@gmail.com       | secret   | true   | user  |       0 |

  Сценарий: Доступ не админу должен быть закрыт к страницам
    Допустим я зашел в сервис как "vlad@gmail.com/secret"
    Если я перешел на страницу "admin_pages"
    То я увижу "Вы не имеете прав для просмотра данной страницы."

  Сценарий: Просмотр списка страниц
    Допустим в сервисе прописан статические страницы "about(id:1), contact(id:2)"
    И я зашел в сервис как "admin_user@gmail.com/secret"
    Если я перешел на страницу "admin_pages"
    То я увижу табличные данные в ".pages_table":
      | Ид | Название | Ссылка  | Действия               |
      |  1 | О нас    | about   | Редактировать\nУдалить |
      |  2 | Контакты | contact | Редактировать\nУдалить |
    И увижу "Добавить страницу"

  Сценарий: Добавление новой страници
    Допустим в сервисе прописан статические страницы "about, contact"
    И я зашел в сервис как "admin_user@gmail.com/secret"
    Если я перешел на страницу "admin_pages"
    И перейду по ссылке "Добавить страницу"
    И введу в поле "page[name]" значение "Пользовательское соглашение"
    И введу в поле "page[permalink]" значение "term_user"
    И введу в поле "page[content]" значение "Такое вот пользовательское соглашение."
    И нажму "Создать страницу"
    То увижу "Страница создана."
    И я увижу "Пользовательское соглашение"

  Сценарий: Редактирование статической страницы.
    Допустим в сервисе прописан статические страницы "about(id:1), contact(id:2)"
    И я зашел в сервис как "admin_user@gmail.com/secret"
    Если я перешел на страницу "admin_pages"
    То я увижу табличные данные в ".pages_table":
      | Ид | Название | Ссылка  | Действия               |
      |  1 | О нас    | about   | Редактировать\nУдалить |
      |  2 | Контакты | contact | Редактировать\nУдалить |
    Если я нажму "Редактировать" для "2" позиции в ".pages_table>tr"
    И введу в поле "page[name]" значение "Снова о нас"
    И нажму "Сохранить"
    То увижу "Данные сохранены."
    И я увижу табличные данные в ".pages_table":
      | Ид | Название    | Ссылка  | Действия               |
      |  1 | О нас       | about   | Редактировать\nУдалить |
      |  2 | Снова о нас | contact | Редактировать\nУдалить |

  Сценарий: Удаление статической страници.
    Допустим в сервисе прописан статические страницы "about(id:1), contact(id:2)"
    И я зашел в сервис как "admin_user@gmail.com/secret"
    Если я перешел на страницу "admin_pages"
    То я увижу табличные данные в ".pages_table":
      | Ид | Название | Ссылка  | Действия               |
      |  1 | О нас    | about   | Редактировать\nУдалить |
      |  2 | Контакты | contact | Редактировать\nУдалить |
    Если я нажму "Удалить" для "2" позиции в ".pages_table>tr"
    То я увижу "Страница удалена."
    И я увижу табличные данные в ".pages_table":
      | Ид | Название | Ссылка | Действия               |
      |  1 | О нас    | about  | Редактировать\nУдалить |

