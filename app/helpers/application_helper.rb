# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(str)
    content_for :title do
      str
    end
  end
end
