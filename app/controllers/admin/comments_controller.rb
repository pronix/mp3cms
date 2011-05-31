class Admin::CommentsController < Admin::ApplicationController
  layout "application"

  filter_access_to :all
  filter_access_to [:edit, :update, :destroy], :attribute_check => true
  before_filter :find_user, :only => :create
  before_filter :find_comment, :only => [:edit, :update, :destroy]


  def index
    @comments = Comment.scoped.paginate(page_options)
  end

  def create
    redirect_to(:back, :alert => "Введите капчу") and return unless verify_recaptcha
    if @comment = commentable.comments.create((params[:comment]||{}).merge({:user => current_user}))
      flash[:notice] = "Комментарий создан"
    else
      flash[:notice] = "Проверьте правильность заполнения всех полей."
    end
    redirect_to commentable
  end

  def edit
    respond_to do |format|
      format.html{ }
      format.js { render :action => "edit", :layout => false }
    end
  end

  def update
    if verify_recaptcha && @comment.update_attributes(params[:comment])
      flash[:notice] = "Комментарий обновлен"
      redirect_admin_or_commentable_object
    else
      render :partial => 'comments/edit'
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = "Комментарий удален"
    redirect_admin_or_commentable_object
  end

  def build_commentable_object
    object_id = params[:object_id]
    if params["switch"] == "playlist"
      @object = Playlist.find object_id
    else
      @object = NewsItem.find object_id
    end
    @object
  end

  def redirect_admin_or_commentable_object
    redirect_to current_user.admin? ? admin_comments_path : @comment.commentable
  end

  private
  def commentable
    @commentable ||= case params[:switch].to_s
                     when "playlist"
                       Playlist.find_by_id(params[:object_id])
                     when "news_item"
                       NewsItem.find_by_id(params[:object_id])
                     end
    @commentable
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

end

