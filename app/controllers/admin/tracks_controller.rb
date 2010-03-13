class Admin::TracksController < Admin::ApplicationController

  before_filter :find_track, :only => [:show, :edit, :update, :destroy, :change_state]
  before_filter :find_user

  def ban

  end

  def index
    @tracks = @user.admin? ? Track.moderation : @user.tracks
  end

  def list
    @state = params[:state]
    @tracks = Track.moderation if @state == "moderation"
    @tracks = Track.active if @state == "active"
    @tracks = Track.banned if @state == "banned"
    @tracks = Track.all if @state.blank? || @state == "all"
  end

  def new
    @track = Track.new
  end

  def edit
  end

  def change_state
    @state = params[:state]
    @track.to_active if @state == "active"
    @track.to_moderation if @state == "moderation"
    @track.to_banned if @state == "banned"
    @track.save
    flash[:notice] = 'Статус трека изменен'
    redirect_to admin_tracks_sort_path("moderation")
  end

  def complete
    if params["delete"]
      Track.delete_all :id => params[:track_ids]
    else
      @state = "banned" if params["banned"]
      @state = "active" if params["active"]
      Track.update_all ["state=?", @state], :id => params[:track_ids] if @state
    end
    redirect_to admin_tracks_path
  end

  def show
  end

  def create
    @track = @user.tracks.build(params[:track])
    if @track.save
      flash[:notice] = 'Трек создан'
      redirect_to admin_track_path(@track)
    else
      render :action => "new"
    end
  end

  def update
    if @track.update_attributes(params[:track])
      flash[:notice] = 'Трек обновлен'
      redirect_to admin_track_path(@track)
    else
      render :action => "edit"
    end
  end

  def destroy
    @track.destroy
    flash[:notice] = 'Трек удален'
    redirect_to admin_tracks_path
  end

  protected

  def find_track
    @track = Track.find(params[:id])
  end

end

