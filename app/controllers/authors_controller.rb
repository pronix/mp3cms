class AuthorsController < ApplicationController

  def index
    @results = Track.search(
                           :conditions => { :author => "^#{params[:char]}*", :state => "active" },
                           :order => :author ,
                           :sort_mode => :desc,
                           :group_by => "author_id",
                           :group_function => :attr,
                           :group_clause   => "@count desc",
                           :page => params[:page], :per_page => 42
                           )
  end

end
