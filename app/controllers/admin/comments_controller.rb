class Admin::CommentsController < Admin::ApplicationController
  layout "application"

  filter_access_to :all
  filter_access_to [:edit, :update, :destroy], :attribute_check => true
  before_filter :find_user, :only => :create
  before_filter :find_comment, :only => [:edit, :update, :destroy]

  def index
    @comments = Comment.find(:all, :order => "id DESC").paginate(page_options)
  end

  def create
    build_commentable_object
    @comment = @object.add_comment @user.comments.build(params[:comment])
    flash[:notice] = "Комментарий создан"
    redirect_to @object
  end

  def edit
    #render :partial => 'comments/edit'
  end

  def update
    if @comment.update_attributes(params[:comment])
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

  protected

  def find_comment
    @comment = Comment.find(params[:id])
  end

end

