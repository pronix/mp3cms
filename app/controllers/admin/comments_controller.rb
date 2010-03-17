class Admin::CommentsController < Admin::ApplicationController

  before_filter :find_user, :only => :create
  before_filter :find_comment, :only => [:edit, :update, :destroy]

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
      redirect_to @comment.commentable
    else
      render :partial => 'comments/edit'
    end
  end

  def destroy
    object = @comment.commentable
    @comment.destroy
    flash[:notice] = "Комментарий удален"
    redirect_to object
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

  protected

  def find_comment
    @comment = Comment.find(params[:id])
  end

end

