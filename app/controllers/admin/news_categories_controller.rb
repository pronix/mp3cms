class Admin::NewsCategoriesController < Admin::ApplicationController
  filter_access_to :all, :attribute_check => false
  inherit_resources
  defaults :resource_class => NewsCategory,
           :collection_name => 'news_categories', :instance_name => 'news_category'

  respond_to :html, :js

  def list_news
    @news_category = NewsCategory.find(params[:id])
    @news_items = @news_category.news_items
  end


  def create
    create! do |success, failure|
      success.html {
        flash[:notice] = "Созданна новая категория новостей"
        redirect_to collection_path }
    end
  end

  def update
    update! do |success, failure|
      success.html {
        flash[:notice] = "Категория новостей обнавленна"
        redirect_to collection_path }
    end
  end

end

