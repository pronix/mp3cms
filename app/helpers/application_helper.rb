# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(str)
    content_for :title do
      str
    end
  end


  # Привлекать пользователя можно ссылаясь на главную, на страницу песни, исполнителя, результат поиска, или плейлист.
  # Перегрузка ссылки, в ссылку добавляеться текущий пользователь
  def link_to(*args, &block)
    options = []
    options << args.first
    options << ((current_user && args.second[/welcome|playlist|track|search|news/] &&
                 !args.second["u=#{current_user.id}"] ) ? (
                                                           args.second['?'] ? args.second << "&u=#{current_user.id}" :
                                                           args.second << "?u=#{current_user.id}"
                                                           ) : args.second)
    options << args.third
    block_given? ? super(*options, &block) :  super(*options)
  end

  # Прямое указание ссылки с параметром пользователя
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

end
