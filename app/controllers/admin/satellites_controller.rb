class Admin::SatellitesController < ApplicationController
#filter_access_to :all, :attribute_check => false

  def index
    @satellites = Satellite.find(:all, :order => "created_at DESC")
    respond_to do |format|
      format.html{ }
      format.json { render :json => [].to_json }
    end
  end

  def new
    @satellite = Satellite.new
  end

  def create
    @satellite = Satellite.new(params[:satellite])
    if @satellite.save
      flash[:notice] = "Новый сервер был привязан к сайту"
      redirect_to admin_satellites_url
    else
      render :action => "new"
    end
  end

  def edit
    @satellite = Satellite.find(params[:id])
  end

  def update
    @satellite = Satellite.find(params[:id])
    @satellite.update_attributes(params[:satellite])
    if @satellite.save
      flash[:notice] = "Параметры сервера были изменены"
      redirect_to admin_satellites_url
    else
      render :action => "edit"
    end
  end

  def destroy
    Satellite.destroy(params[:id])
    redirect_to :back
  end
  
end
