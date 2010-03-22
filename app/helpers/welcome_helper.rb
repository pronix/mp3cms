module WelcomeHelper

  def generate_search_link(lastrequest)
    link = "<li>"
    case lastrequest[:url_model]
      when "track"
        link += "<a href='searches/?model=#{lastrequest[:url_model]}&search_track=#{lastrequest[:url_string]}&attribute=#{lastrequest[:url_attributes]}&remember=no'>#{lastrequest[:url_string]}</a>"
      when "playlist"
        link += "<a href='searches/?model=#{lastrequest[:url_model]}&search_playlist=#{lastrequest[:url_string]}&remember=no'>#{lastrequest[:url_string]}</a>"
      when "news_item"
        link += "<a href='searches/?model=#{lastrequest[:url_model]}&search_track=#{lastrequest[:url_string]}&remember=no'>#{lastrequest[:url_string]}</a>"
    end
    link += "</li>"
  end

end

