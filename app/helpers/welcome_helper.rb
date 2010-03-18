module WelcomeHelper

  def generate_search_link(lastrequest)
    link = "<li>"
    link = "<a href=/search/#{lastrequest.site_section}?search=#{lastrequest.search_string}&site_attributes=#{lastrequest.site_attributes}>#{lastrequest.search_string}</a>"
    link += "</li>"
  end

end

