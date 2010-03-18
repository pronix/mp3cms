# -*- coding: utf-8 -*-
# Управление скачиванием файлов.

class Download
  INTERNAL_PATH = "internal_download" # ссылка на внутренний редирек в nginx

  def initialize(app)
    @app = app
  end


  def call(env)
    case env["PATH_INFO"]
      # Скачивание файл
      # если метод запроса HEAD - то это запрос на метаданные (размер файла, ...)
      # если метод запроса GET - то этот запрос на скачивание файла
      # параметры в url - id FileLink
      # о запросе потока мы узнаем по наличию параметра env['HTTP_RANGE']

    when /^\/download/
      begin
        # получаем запись о ссылке скачивания
        @file_link_id =  /(\w{32})/.match(env["PATH_INFO"])
        @file_link = FileLink.find_by_link(@file_link_id.to_s)
        request = Rack::Request.new(env)


        # Проверяем что запись найдена
        # Проверяем что время жизни ссылки не истекло
        # Проверяем что ип адресс совпадает с адресом клиента

        raise "Ссылка не найдена"    unless @file_link
        raise "Время ссылки истекло" if @file_link.expired?
        raise "Не тот ip адрес"      unless @file_link.ip == request.ip


        case env["REQUEST_METHOD"]
        when /HEAD/
          # Запрос метаданных
          # нужно отдать метаданные чтоб менеджеры загрузок нормально работали
          # метаданные можно отдавать если
          #  Доступна для скачивания
          #  Файл качается
          #  Скачивание приостановлено

          if @file_link.available? || @file_link.swings? || @file_link.suspended?
            @headers = set_heades(@file_link)
            [200, @headers, "ok!"]
          else
            raise "Not found"
          end

        when /GET/
          # запрашивают файл
          if env['HTTP_RANGE'] =~ /bytes=(\d+)-(\d*)/ then
            # запрашивают часть файла
            # часть файла можно отдавать если ссылка нах-ся состоянии
            #  Файл качается
            @from_byte  = $1
            @to_byte = $2 unless $2.nil?
            @headers = set_heades(@file_link).
              merge!({
                       'Content-Range' => "bytes #{@from_byte}-#{@to_byte}/#{@file_link.file_size.to_s}",
                       'Content-Length' => "#{@to_byte.to_i - @from_byte.to_i + 1}",
                       'X-Accel-Redirect' => "/#{INTERNAL_DOWNLOAD}/#{@file_link.file_path.to_s}"
                     })
            [206, @headers, "ok!"]

          else

            # запрашивают целиком файл
            # файл можно отдать если ссылка имеет статус #  Доступна для скачивания
            # после того как файл был отдан на скачивание нужно установить статус ссылки как скачиваемый
            @headers = set_heades(@file_link).
              merge!({'X-Accel-Redirect' => "/#{INTERNAL_DOWNLOAD}/#{@file_link.file_path.to_s}" })
            [200, @headers, "ok!"]
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

  def set_heades(file_link)
    {
      'Accept-Ranges'             => 'bytes',
      'Content-Length'            => file_link.file_size.to_s,  # размер файла
      'Content-Disposition'       =>  "attachment; filename=#{file_link.file_name}", # имя файла с расширением
      'Content-Type'              => file_link.content_type.to_s,  # тип файла
      'X-Accel-Limit-Rate'        => file_link.speed.to_s,         # скорость скачивания
      "Content-Transfer-Encoding" => 'binary'
    }
  end

  def log message
    Rails.logger.info [" [ Dwnload file: ] ", message].join
  end
end
