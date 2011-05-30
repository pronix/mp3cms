class Admin::SatellitesController < Admin::ApplicationController
  filter_access_to :all, :attribute_check => false

  def newmaster
    master = Satellite.find_by_master(true);
    if master
      new_master = Satellite.find(params[:server])
      if master == new_master
        flash[:error] = "Выбранный вами сервер уже является основным сервером хранения mp3"
      else
        new_master.set_master
        flash[:notice] = "Сервер хранения mp3 был изменён"
      end
    else
      if params[:server].blank?
        flash[:notice] = "Вы должны выбрать будующий сервер хранения mp3 из списка доступных."
      end
    end
    #FIXME надо перезагружать только один класс вместо всего сервера
    `touch tmp/restart.txt` # это необходимо для того что б паперклипе новый путь к файлу задавался

    redirect_to :back
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

    # Если серверов в списке нет, то первый добавленный возьмёт на себя хранение mp3
    if Satellite.count == 0
      @satellite.update_attribute(:master,true)
    end

    if @satellite.save
      # если успешно сохранился - то к серверу надо подключиться и выполнить ряд действий
      # через delayed_job
      #      Delayed::Job.enqueue SatelliteJob.new @satellite.id

      unless Rails.env =~ /test/ # пропуск при тестирование
        sat = @satellite
        ip = sat.ip

        puts system("scp -r /var/www/mp3cms/current/doc/satelite/* root@#{ip}:/root/")
        puts system("ssh root@#{ip} 'chmod +x /root/autodeploy.sh ; mkdir -p /var/www/data ; /root/autodeploy.sh;'")
        puts system("ssh root@#{ip} 'sed -i 's/mp3koza/#{sat.community}/''")
        # тестируем
        # после успешной проверки ставим что сервер активен
        puts system("mkdir -p /var/www/mp3cms/shared/data/tracks/#{sat.id} ")
        puts system("sshfs root@#{ip}:/var/www/data /var/www/mp3cms/shared/data/tracks/#{sat.id} -o umask=770 ")
        sat.active = true
        sat.save!
      end

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
