=begin rdoc
Блокировка доступа к сервису по ип адресу.
Проверяем ип адреса и адреса заблокированных пользователей, если есть то блокируем запрос и выдаем сообщение о блокировки.

=end
class BlockingIp
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    if User.bans.ip_ban(request.ip).count > 0
      Rails.logger.debug '-'*90
      Rails.logger.debug "[blocking on ip address] #{request.ip} "
      Rails.logger.debug '-'*90
      [ 200,
        {"Content-Type" => "text/html", "Location" => "#{env['rack.url_scheme']}://#{env['SERVER_NAME']}/blocking" },
        [File.read(File.join(Rails.root,'public', 'blocking.html' ))]
      ]
    else
      @app.call(env)
    end
  end
end
