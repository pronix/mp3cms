class Admin::CommentsController < Admin::ApplicationController
  layout "application"
  # validates_captcha :only => [:create, :update]

  filter_access_to :all
  filter_access_to [:edit, :update, :destroy], :attribute_check => true
  before_filter :find_user, :only => :create
  before_filter :find_comment, :only => [:edit, :update, :destroy]


  def index
    @comments = Comment.find(:all, :order => "id DESC").paginate(page_options)
  end

  def create
    redirect_to(:back, :alert => "Введите капчу") and return unless verify_recaptcha
    build_commentable_object

    params[:comment][:comment] = params[:comment][:comment].split(" ")[0..40]

    @com = @object.comments.new
    @com.comment = params[:comment][:comment]
    @com.user_id = @user.id
    @com.name = @user.login
    @com.email = @user.email

    if @com.save
      flash[:notice] = "Комментарий создан"
    else
      flash[:notice] = "Проверьте правильность заполнения всех полей."
    end
    redirect_to @object
  end

  def edit
    #render :partial => 'comments/edit'
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

  protected

  def find_comment
    @comment = Comment.find(params[:id])
  end

end

