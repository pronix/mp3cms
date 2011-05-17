  require "populator"
  require "faker"
  # Добавляем категории новостей + новости в этих категориях + связи между новостяни и категориями


    NewsItem.populate 4 do |newsitem|
      newsitem.header = Populator.words(2..4).titleize
      newsitem.text = Populator.words(200..300).titleize
      newsitem.news = true
      newsitem.delta = true
      newsitem.meta = Populator.words(4..7).titleize
      newsitem.description = Populator.words(30..40)
      newsitem.created_at = Time.now
      newsitem.user_id = User.offset(rand(User.count)).first.try(:id)
      newsitem.state = ["active", "moderation"]

      num_comments = rand(1) + 2
      newsitem.comments_count = num_comments
      Comment.populate num_comments do |comment|
        comment.name = Populator.words(1..2)
        comment.email = User.offset(rand(User.count)).first.try(:email)
        comment.comment = Populator.words(20.40)
        comment.commentable_id = newsitem.id
        comment.commentable_type = "NewsItem"
        comment.user_id = User.offset(rand(User.count)).first.try(:id)
      end
  end

