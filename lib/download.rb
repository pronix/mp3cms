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
      # при загрузке на удаленный сервер - данные по файлу передаются
    when /api\/set/
      # при попытке скачать
    when /api\/get/
      #приходит запрос domain.com/download/hfhfhfldhdj.mp3
      #отправляем на центральный сервер ip и имя строку запроса + secret key(на всякий случай)
      req = Rack::Request.new(env)
      req.params["data"]
      flink = FileLink.envfind(req.params[:uri])
      if flink && flink.ip == req.params[:ip] && !flink.expired? && check_ip(req.ip)# нужно вписать проверку хеша
      #получаем ответ "можно отдать" + путь до файла
      #отдаем файл
        flink.to_swings!
        [200, {"Content-Type" => "text/html"  }, "ok!!! #{flink.file_path}"]
      else
        [404, {"Content-Type" => "text/html"  }, "false"]
      end
    when /cut_track\/\w{40}/
      # получение файла на нарезку
      @hash_id = /(\w{40})/.match(env["PATH_INFO"]).to_s
      session = env["rack.session"]

      @track_id = session[:cut_links][@hash_id][:id] if Time.now.to_i <  session[:cut_links][@hash_id][:time].to_i rescue nil
      session[:cut_links] = { }
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
      @track = Track.find @track_id if @track_id && !session[:listen_track].blank? &&
        session[:listen_track].split(';').include?(@track_id.to_s)
      if @track
        @headers = {
          'Accept-Ranges'             => 'bytes',
          'Content-Length'            =>  @track.data_file_size.to_s,  # размер файла
          'Content-Disposition'       =>  "attachment; filename=#{@track.data_file_name.to_s}",
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
        'X-Accel-Redirect' => "/#{INTERNAL_PATH}/rdd/#{file_image}"
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


        if env["PATH_INFO"].to_s.include?("archive")

          @format = "zip"
          @file_link = ArchiveLink.envfind(env["PATH_INFO"])
          @short_path = "archives/#{@file_link.archive_id}/#{@file_link.file_name}"

        else

          @format = /(\w{3}$)/.match(env["PATH_INFO"]).to_s
          @file_link = FileLink.envfind(env["PATH_INFO"])
          @short_path = "tracks/#{@file_link.track_id}/#{@file_link.file_name}"

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

