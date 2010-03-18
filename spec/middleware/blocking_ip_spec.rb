require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require "rack/test"
describe BlockingIp, "Блокировка пользователя по ип адресу" do
  include Rack::Test::Methods
  def app
      ActionController::Dispatcher.new
  end
  context "Если в сервисе есть заблокированный пользователь с ип адресом 109.191.48.196" do
    before :each do
      User.destroy_all
      Role.destroy_all
      Factory(:user_role)
      Factory(:user,
              :login => "test@gmail.com", :email => "test@gmail.com",
              :password => "secret", :password_confirmation => "secret",
              :current_login_ip => '109.191.48.196',
              :ban => true, :type_ban => 2, :start_ban => Time.now.to_s(:db), :end_ban => (Time.now+3.days).to_s(:db)
              )
    end
    it "должен выдать страницу с информации о бокирование если ип адрес запроса 109.191.48.196" do
      get '/',{ },{"REMOTE_ADDR" => "109.191.48.196" }

      last_response.body.should == File.read(File.join(RAILS_ROOT,'public', 'blocking.html' ))
      last_response.headers.should ==  { 'Location' => 'http://example.org/blocking',
                                         'Content-Type' => 'text/html'}
    end

    it "должен продолжить обычный запрос если ип адрес запроса не равен 109.191.48.196" do
      get '/',{ },{"REMOTE_ADDR" => "109.191.48.106" }
      last_response.body.should_not == File.read(File.join(RAILS_ROOT,'public', 'blocking.html' ))
    end
  end

end
