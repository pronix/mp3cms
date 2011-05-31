class CommentsController < ApplicationController
  before_filter :require_user
  filter_access_to :all
  filter_access_to [:edit, :update, :destroy], :attribute_check => true

  before_filter :check_commentable
  helper_method :commentable

  # Созданеи комментария
  #
  def create
    redirect_to(:back, :alert => "Введите капчу") and return unless verify_recaptcha

    if @comment = commentable.comments.create((params[:comment]||{}).merge({:user => current_user}))
      flash[:notice] = "Комментарий создан"
    else
      flash[:notice] = "Проверьте правильность заполнения всех полей."
    end
    redirect_to commentable
  end


  # Редактирование комментария
  #
  def edit

    @comment = commentable.comments.find_by_id(params[:id])
    respond_to do |format|
      format.html{ }
      format.js { render :action => "edit", :layout => false }
    end
  end


  # Обновление комментария
  #
  def update
    redirect_to(:back, :alert => "Введите капчу") and return unless verify_recaptcha
    @comment = commentable.comments.find_by_id(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Комментарий обновлен"
    end
    redirect_to commentable
  end

  # Удаление комментария
  #
  def destroy
    if (@comment = commentable.comments.find_by_id(params[:id])) &&  @comment.destroy
      flash[:notice] = "Комментарий удален"
    else
      flash[:error] =  "Комментарий не удален"
    end
    redirect_to commentable
  end


  private
  def commentable
    @commentable ||= case params[:object_type].to_s
                     when "playlist"
                       Playlist.find_by_id(params[:object_id])
                     when "newsitem"
                       NewsItem.find_by_id(params[:object_id])
                     end
    @commentable
  end

  def check_commentable
    redirect_to :back, :notice => "Не указаны родительские объекты" and return if commentable.blank?
  end

end
