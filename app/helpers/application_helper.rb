# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(str)
    content_for :title do
      str
    end
  end

  # Перегрузка ссылки, в ссылку добавляеться текущий пользователь
  # def link_to(*args, &block)
  #   options = []
  #   options << args.first
  #   options << (current_user ? (
  #                               args.second['?'] ? args.second << "&u=#{current_user.id}" :
  #                               args.second << "?u=#{current_user.id}"
  #                               ) : args.second)
  #   options << args.third
  #   if block_given?
  #     super(*options, &block)
  #   else
  #     super(*options)
  #   end
  # end

end
