module WelcomeHelper

  def generate_search_link(lastrequest)
    link = "<li>"
    case lastrequest[:url_attributes]
      when "author title"
        link += "<a href='searches?search_track=#{lastrequest[:url_string]}&author=yes&title=yes&model=track&remember=no'>#{lastrequest[:url_string]}</a>"
      when "author"
        link += "<a href='searches?search_track=#{lastrequest[:url_string]}&author=yes&model=track&remember=no'>#{lastrequest[:url_string]}</a>"
      when "title"
        link += "<a href='searches?search_track=#{lastrequest[:url_string]}&title=yes&model=track&remember=no'>#{lastrequest[:url_string]}</a>"
    end
    link += "</li>"
  end

end

