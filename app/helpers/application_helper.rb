# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def tags(news)
    news.meta.split(" ")
    news.meta.split(" ").collect { |tag|
      options = { :search_string => tag, :attribute => "meta", :model => 'news_item'}
      link = link_to(tag, searches_path(options))
      link.blank? ? nil : ["<li> ",link,"</li> "]
    }
  end

  def show_tag_could
    tag_coulds = TagCloud.find(:all).sort_by{ rand }
    tag_coulds.map do |tag_could|
      url = URI.escape(tag_could[:url_string])
      _options = { :search_string => url, :rel => 'tag', :remember => 'no'}
      options = case tag_could[:url_attributes]
                when "author title" then _options.merge({ :author => 'yes', :title => 'yes', :model => 'track'})
                when "author"       then _options.merge({ :author => 'yes', :model => 'track'})
                when "title"        then _options.merge({ :title => 'yes', :model => 'track'})
                else
                  case tag_could[:url_model]
                  when /playlist/  then _options.merge({ :title => 'yes', :model => 'playlist'})
                  when /news_item/ then _options.merge({ :title => 'yes', :model => 'news_item'})
                  else
                    nil
                  end
                end

      link = options.blank? ? nil : link_to(tag_could[:url_string], searches_path(options),
                                            :class => "w#{tag_could.font_size}" )
      link.blank? ? nil : ["<li> ",link,"</li> "]
    end.flatten.compact.join
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

  # ссылка или форма логина
  def link_to_or_login(*args, &block)
    current_user ? link_to(*args, &block) : link_to(I18n.t('login'), login_path, :class => "js_link", :data_size => "200x500")
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

