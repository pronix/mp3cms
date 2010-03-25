# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_tag_could
    tag_coulds = TagCloud.find(:all).rand
    links = ""
    for tag_could in tag_coulds
      links += "<li>"
      case lastrequest[:url_attributes]
        when "author title"
          links += "<a href='searches?search_track=#{tag_could[:url_string]}&author=yes&title=yes&model=track&remember=no rel='tag' class='w#{tag_could.font_size}'>#{tag_could[:url_string]}</a>"
        when "author"
          links += "<a href='searches?search_track=#{tag_could[:url_string]}&author=yes&model=track&remember=no rel='tag' class='w#{tag_could.font_size}'>#{tag_could[:url_string]}</a>"
        when "title"
          links += "<a href='searches?search_track=#{tag_could[:url_string]}&title=yes&model=track&remember=no rel='tag' class='w#{tag_could.font_size}'>#{tag_could[:url_string]}</a>"
      end
      links += "</li>"
    end

  end

  def title(str)
    content_for :title do
      str
    end
  end

  def _title(str)
    content_for :title do
      str
    end
  end


  def paginate(collection)
    will_paginate(collection,
      :prev_label => "&#171; Назад",
      :next_label => "Вперед &#187;"
    )
  end

  # Привлекать пользователя можно ссылаясь на главную, на страницу песни, исполнителя, результат поиска, или плейлист.
  # Перегрузка ссылки, в ссылку добавляеться текущий пользователь
  def link_to_with_referrer(*args, &block)
    options = []
    options << args.first
    options << (current_user ? (
                                args.second['?'] ? args.second << "&u=#{current_user.id}" :
                                args.second << "?u=#{current_user.id}"
                                ) : args.second)
    options << args.third
    block_given? ? link_to(*options, &block) : link_to(*options)
  end

  def mb(size)
    number_to_human_size(size)
  end

end

