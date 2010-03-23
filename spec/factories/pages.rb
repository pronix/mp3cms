Factory.define :about_page, :class => Page do |pg|
  pg.name "О нас"
  pg.permalink "about"
  pg.content "Здесь мы пишем о сервисе"
end

Factory.define :contact_page, :class => Page do |pg|
  pg.name "Контакты"
  pg.permalink "contact"
  pg.content "Здесь мы пишем наши контакты"
end
