# -*- coding: utf-8 -*-
# Управление скачиванием файлов.


class Download
  INTERNAL_PATH = "internal_download" # ссылка на внутренний редирек в nginx

  def initialize(app)
    @app = app
  end

  def call(env)

    @env = env

    case env["PATH_INFO"]
    # Опрашиваем джава скриптом на предмет ответов на заказы песен форман запроса "check_order?user_id"
    when /check_order/

      #rack.logger(@app)
      req = Rack::Request.new(env)
      Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(req)
      current_user = UserSession.find
      orders = current_user.user.tenders.all(:include => :order, :conditions => ["orders.state = 'notfound' and tenders.state != 'read' and tenders.tender_state == 'approved'"]).map(&:order).uniq
      #checktenders = CheckTender.find_all_by_user_id(req.params["user_id"])
      messages = []
      unless orders.blank?
        orders.each do |order|
          messages << "<a href=/orders/#{order.id}>Ордер: #{order.id}</a><br />"
          #checktender.destroy()
        end
        [200, {"Content-Type" => "text/html"}, [ {:status => :ok, :messages => messages.join}.to_json ] ]
      else
        [200, {"Content-Type" => "text/html"  }, [ {:status => :no }.to_json ]]
      end

      # при попытке скачать
    when /api\/get/
      #приходит запрос domain.com/download/hfhfhfldhdj.mp3
      #отправляем на центральный сервер ip и имя строку запроса + secret key(на всякий случай)
      req = Rack::Request.new(env)
      req.params["data"]
      flink = FileLink.envfind(req.params['uri'].to_s.gsub(/\w\w\w$/,'').gsub('.',''))
      fname = flink.track.author.gsub(/\ |\'|\"|\?/,'_') + '_' + flink.track.title.gsub(/\ |\'|\"|\?/,'_')
      if flink && flink.ip == req.params['ip'] && !flink.expired? && check_ip(req.ip)# нужно вписать проверку хеша
      #получаем ответ "можно отдать" + путь до файла
      #отдаем файл
        flink.to_swings! rescue ''
        [200, {"Content-Type" => "text/html"  }, "ok!!! fname=#{fname} fpath=#{flink.file_path.split(/\d\d\d\d\d+/).last}"]
      else
        [404, {"Content-Type" => "text/html"  }, "false"]
      end
    when /cut_track\/\w{40}/
      # получение файла на нарезку
      @hash_id = /(\w{40})/.match(env["PATH_INFO"]).to_s
      session = env["rack.session"]

      @track_id = session[:cut_links][@hash_id][:id] # if Time.now.to_i <  session[:cut_links][@hash_id][:time].to_i rescue nil

      @track = Track.find @track_id if @track_id
      @headers = {
        'Accept-Ranges'             => 'bytes',
        'Content-Length'            =>  @track.data_file_size.to_s,  # размер файла
        'Content-Disposition'       =>  "attachment; filename=#{@track.data_file_name.to_s}",
        'Content-Type'              =>  "application/mp3",  # тип файла
        "Content-Transfer-Encoding" => 'binary',
        'X-Accel-Redirect' => "/#{INTERNAL_PATH}/#{@track.data.url}"
      }

      [206, @headers, "ok!"]

    when /listen_track\//

      @track_id = /listen_track\/(\w+)/.match(env["PATH_INFO"]).to_s
      @track_id = $1
      session = env["rack.session"]
      log session[:listen_track]
      @track = Track.find @track_id # if @track_id && !session[:listen_track].blank? &&
        # session[:listen_track].split(';').include?(@track_id.to_s)
      if @track
        @from_byte = 0
        @to_byte = @track.data_file_size.to_i / 10

        @headers = {
          'Accept-Ranges'             => "bytes #{@from_byte}-#{@to_byte}/#{@track.data_file_size}",
          'Content-Length'            =>  "#{@to_byte.to_i - @from_byte.to_i + 1 }",  # размер файла
          'Content-Disposition'       =>  "attachment; filename=#{@track.track_name}",
          'Content-Type'              =>  "application/mp3",  # тип файла
          "Content-Transfer-Encoding" => 'binary',
          'X-Accel-Redirect' => "/#{INTERNAL_PATH}/#{@track.data.url}"
        }

        [206, @headers, "ok!"]
      else
        [404, {"Content-Type" => "text/html"  }, "Not found track!"]
      end

    when /network.png|diskio.png/
      file_image =env["PATH_INFO"].split(/\//).last
      @headers = {
        "Content-Type" => "image/png",
        'X-Accel-Redirect' => "/#{INTERNAL_PATH}/rrd/#{file_image}"
      }
      [200, @headers, "ok!"]

      # Скачивание файл
      # если метод запроса HEAD - то это запрос на метаданные (размер файла, ...)
      # если метод запроса GET - то этот запрос на скачивание файла
      # параметры в url - id FileLink
      # о запросе потока мы узнаем по наличию параметра env['HTTP_RANGE']

    when /^\/download/
      begin
        # получаем запись о ссылке скачивания
        @file_link_id = /(\w{32})/.match(env["PATH_INFO"]).to_s




        if env["PATH_INFO"].to_s.include?("archive")
          @format = "zip"
          @file_link = ArchiveLink.find_by_link(@file_link_id)
          @short_path = "archives/#{@file_link.archive_id}/#{@file_link.file_name}"
        else
          @format = /(\w{3}$)/.match(env["PATH_INFO"]).to_s
          @file_link = FileLink.find_by_link(@file_link_id)
          @short_path = @file_link.track.data.url
        end

        request = Rack::Request.new(env)

        # Проверяем что запись найдена
        # Проверяем что время жизни ссылки не истекло
        # Проверяем что ип адресс совпадает с адресом клиента

        raise "Ссылка не найдена"    unless @file_link
        raise "Время ссылки истекло" if @file_link.expired?
        raise "Не тот ip адрес"      unless @file_link.ip == env['REMOTE_ADDR']

        case env["REQUEST_METHOD"]
        when /HEAD/
          # Запрос метаданных
          # нужно отдать метаданные чтоб менеджеры загрузок нормально работали
          # метаданные можно отдавать если
          #  Доступна для скачивания
          #  Файл качается
          #  Скачивание приостановлено

          if @file_link.available? || @file_link.swings? || @file_link.suspended?
            @headers = set_heades(@env, @file_link, @format)
            [200, @headers, "ok!"]
          else
            raise "Not found"
          end

        when /GET/
          # запрашивают файл
          if env['HTTP_RANGE'] =~ /bytes=(\d+)-(\d*)/
            # запрашивают часть файла
            # часть файла можно отдавать если ссылка нах-ся состоянии
            #  Файл качается
            @from_byte  = $1
            @to_byte = $2 unless $2.nil?

            if @file_link.swings? and @from_byte > 0
              @headers = set_heades(@env, @file_link, @format).
                merge!({
                         'Content-Range' => "bytes #{@from_byte}-#{@to_byte}/#{@file_link.file_size.to_s}",
                         'Content-Length' => "#{@to_byte.to_i - @from_byte.to_i + 1}",
                         'X-Accel-Redirect' => "/#{INTERNAL_PATH}/#{@short_path.to_s}"
                       })
              [206, @headers, "ok!"]
            else
              raise "You can't download"
            end

          else

            # запрашивают целиком файл
            # файл можно отдать если ссылка имеет статус #  Доступна для скачивания
            # после того как файл был отдан на скачивание нужно установить статус ссылки как скачиваемый

            if @file_link.available? || @file_link.swings?

                @file_link.to_swings! unless @file_link.swings?

              @headers = set_heades(@env, @file_link, @format).
                merge!({'X-Accel-Redirect' => "/#{INTERNAL_PATH}/#{@short_path.to_s}" })
              [200, @headers, "ok!"]

            else
              raise "You can't download тут"
            end

          end
        else #если другими методами то говорим о ошибке
          raise "Не верный запрос"
        end

      rescue => ex
        log ex.message
        [405, {"Content-Type" => "text/html" }, ex.message ]
      end
    else
      @app.call(env)
    end
  end

  private

  def set_heades(env, file_link, format = nil)

    if env["PATH_INFO"].to_s.include?("archive")
      format = "zip" unless format
      {
        'Accept-Ranges'             => 'bytes',
        'Content-Length'            => file_link.file_size.to_s,  # размер файла
        'Content-Disposition'       =>  "attachment; filename=#{file_link.file_name}", # имя файла с расширением
        'Content-Type'              => file_link.content_type.to_s,  # тип файла
        'X-Accel-Limit-Rate'        => file_link.speed.to_s,         # скорость скачивания
        "Content-Transfer-Encoding" => 'binary'
      }
    else
      format = "mp3" unless format
      {
        'Accept-Ranges'             => 'bytes',
        'Content-Length'            => file_link.file_size.to_s,  # размер файла
        'Content-Disposition'       =>  "attachment; filename=#{file_link.file_name.to_s.gsub("mp3", format)}", # имя файла с расширением
        'Content-Type'              => file_link.build_content_type(format),  # тип файла
        'X-Accel-Limit-Rate'        => file_link.speed.to_s,         # скорость скачивания
        "Content-Transfer-Encoding" => 'binary'
      }
    end

  end

  def log message
    Rails.logger.info [" [ Download file: ] ", message].join
  end

  def check_ip(ip)
    Satellite.find_by_ip ip
  end
end

