class Mp3CutsController < ApplicationController
  CUT_PATH = File.join(RAILS_ROOT, 'tmp', 'mp3_cut')
  before_filter :require_user
  filter_access_to :all, :attribute_check => false
  before_filter :check_balance

  # выводим пользователю форму для нарезки файла
  def show
    @track = current_user.tracks.find params[:id]
    @hash_link = SecureRandom.hex(20)
    @temp_url = "cut_track/#{@hash_link}"
    @length = Mp3Info.open(@track.data.path).length rescue 0
    @length_to_s = convert_seconds_to_time(@length)

    session[:cut_links] ||= { }
    session[:cut_links][@hash_link] = { :time => (Time.now+2.minutes).to_i, :id => @track.id }
  end


  # Выполняем нарезку файла и возвращем полученный файл
  # получаем ид трека и временные границы
  def cut
    @track = current_user.tracks.find_by_id params[:id]
    raise "Not found track" if @track.blank?
    raise "Не хватает денег" if current_user.balance < Profit.find_by_code("assorted_track").amount
    @time_range = [convert_seconds(params[:time][:start]), convert_seconds(params[:time][:stop])].flatten

    @word= Array.new(100){ ['A'..'Z'].map{ |r| r.to_a }.flatten[ rand( ['A'..'Z'].map{ |r| r.to_a }.flatten.size ) ] }.join
    @tmp_file = FileUtils.mkdir_p(CUT_PATH) &&
      File.join(CUT_PATH, Digest::MD5.hexdigest([request.remote_ip, Time.now.to_i,@word].join))
    @command = "#{Settings[:mp3_cut_command]} -o #{@tmp_file} -t %02d:%02d:%02d+000-%02d:%02d:%02d+000 #{@track.data.path}"%@time_range

    `#{@command}`
    current_user.debit_assorted_track("Нарезка трека")
    send_file  @tmp_file, :filename => @track.data_file_name, :content_type => 'application/mp3'
  rescue => ex
    flash[:error] = ex.message
    redirect :action => "show"
  end

  private

  def check_balance
    if current_user.balance < Profit.find_by_code("assorted_track").amount
      flash[:error] = "Не хватает денег"
      redirect_to :back
    end
  end

  def convert_seconds_to_time(l)
    time = convert_seconds(l)
    "#{time.second}:#{time.last}"
  end
# получаем из секунд часы, минуты, секунды
  def convert_seconds(t)
    t = t.to_i
    h = (t/1.hours).to_i
    m = ((t-h.hours)/1.minute).to_i
    s = ((t-h.hours - m.minutes)/1.second).to_i
    [h,m,s]
  end
end
