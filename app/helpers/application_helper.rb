# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # Подпись в писмах
  #
  def sign_notification
    %Q(
    Служба тех. поддержки: #{ auto_link_email_addresses( Settings.support_email) }
    ).html_safe
  end
  def error_messages!(target)
    return "" if target.blank? || target.errors.empty?

    messages = target.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <div class='red'>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe

  end
  def link_to_cart
    link_to "Корзина (#{current_user.cart_tracks.size rescue '0'})", carts_path
  end

  def link_image(image)
    options = { :onclick => "return hs.expand(this)", :class => "highslide" }
    link_to(image_tag(image.photo.url(:thumb)), image.photo.url(:medium), options)
  end

  def tags(news)
    news.meta.split(",")
    news.meta.split(",").collect { |tag|
      options = { :q => tag.strip, :attribute => "meta", :model => 'news_item'}
      link = link_to(tag.strip, searches_path(options))
    }
  end

  def show_tag_could
    tag_coulds = TagCloud.all.sort_by{ rand }
    html  = ""
    tag_coulds.each do |tag|
      @url = tag[:url_string].to_s.gsub('*','')
      options = { :q => @url, :rel => :'tag', :remember => :'no', :model => :'track'}
      case tag[:url_attributes]
      when "author title"
        options[:author] = :"yes"
        options[:title] = :'yes'
      when "author"
        options[:author] = :'yes'
      when "title"
        options[:title] = :'yes'
      else
        case tag[:url_model]
        when /playlist/
          options[:title]  = :'yes'
          options[:model] = :'playlist'
        when /news_item/
          options[:title] = :'yes'
          options[:model] = :'news_item'
        else
          options = nil
        end
      end

      html << link_to(@url, searches_path(options), :class => "tag-elem#{tag.font_size}" ) unless options.blank?
    end

    html.html_safe

  end


  def paginate(collection)
    if collection && collection.respond_to?(:total_pages)
      will_paginate(collection,
                    :prev_label => "&#171; Назад",
                    :next_label => "Вперед &#187;"
                    )
    end
  end

  # ссылка или форма логина
  def link_to_or_login(*args, &block)
    current_user ? link_to(*args, &block) : link_to(I18n.t('login'), login_path, :class => "js_link", :data_size => "250x450")
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

  def link_to_archive_link_of(archive_id)
    link = ArchiveLink.find_for_user(current_user, archive_id).first
    link_to archive_link_url(link.link), archive_link_url(link.link)
  end

end

