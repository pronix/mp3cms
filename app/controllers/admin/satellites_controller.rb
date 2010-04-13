class Admin::SatellitesController < ApplicationController
#filter_access_to :all, :attribute_check => false

  def newmaster
    master = Satellite.find_by_master(true);
    if master
      new_master = Satellite.find(params[:server])
      if master == new_master
        flash[:error] = "Выбранный вами сервер уже является основным сервером хранения mp3"
        redirect_to :back
      else
        master.master = false
        new_master.master = true
        master.save
        new_master.save
        flash[:notice] = "Сервер хранения mp3 был изменён"
        redirect_to :back
      end
    else
      if params[:server].blank?
        flash[:notice] = "Вы должны выбрать будующий сервер хранения mp3 из списка доступных."
        redirect_to :back
      end
    end
  end

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
    if Satellite.count == 0
      @satellite.update_attribute(:master,true)
    end

    if @satellite.save
      # если успешно сохранился - то к серверу надо подключиться и выполнить ряд действий
      # через delayed_job
      Delayed::Job.enqueue SatelliteJob.new @satellite.id
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
    satellite = Satellite.find(params[:id])
    if satellite.master == true
      flash[:error] = "Прежде чем удалить сервер хранения mp3, перенесите его обязанности на другой сервер"
      redirect_to admin_satellites_url
    else
      Satellite.destroy(params[:id])
      flash[:error] = "Сервер был успешно удалён"
      redirect_to :back
    end
  end
  
end
