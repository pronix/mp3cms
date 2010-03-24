  require "populator"

  [NewsItem, Newsship, NewsCategory].each(&:delete_all)

  # Добавляем категории новостей + новости в этих категориях + связи между новостяни и категориями
  NewsCategory.populate 1 do |news_category|
    news_category.name = Populator.words(2..4).titleize
    NewsItem.populate 3 do |newsitem|
      newsitem.header = Populator.words(2..4).titleize
      newsitem.text = Populator.words(20..30).titleize
      newsitem.meta = Populator.words(4..7).titleize
      newsitem.news_category_id = news_category.id
      newsitem.description = Populator.words(30..40)
      newsitem.created_at = Time.now
      Newsship.populate 1 do |newsship|
        newsship.news_category_id = news_category.id
        newsship.news_item_id = newsitem.id
      end
    end
  end

