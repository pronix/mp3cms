class AuthorsController < ApplicationController

  def index
    @results = Track.group_by_author(params)
  end

end
