require "mp3_cut"
class Mp3CutsController < ApplicationController
  before_filter :require_user
  filter_access_to :all, :attribute_check => false
  before_filter :check_balance

  # выводим пользователю форму для нарезки файла
  def show
    @track = Track.find params[:id]
    @hash_link = SecureRandom.hex(20)
    @temp_url = "/cut_track/#{@hash_link}"
    @length = Mp3Info.open(@track.data.path).length rescue 0
    @length_to_s = convert_seconds_to_time(@length)

    session[:cut_links] ||= { }
    session[:cut_links][@hash_link] = { :time => (Time.now+2.minutes).to_i, :id => @track.id }
  end


  # Выполняем нарезку файла и возвращем полученный файл
  # получаем ид трека и временные границы
  def cut
    @track = Track.find_by_id params[:id]
    raise "Трек не найден" if @track.blank?
    raise "Не хватает денег" if current_user.balance < Profit.find_by_code("assorted_track").amount
    @tmp_file = Mp3Cut.cut(@track, params[:time][:start], params[:time][:stop])
    current_user.debit_assorted_track("Нарезка трека")
    send_file  @tmp_file, :filename => @track.data_file_name, :content_type => 'application/mp3'
  rescue => ex
    flash[:error] = ex.message
    redirect_to :action => "show"
  end

  private

  def check_balance
    unless current_user.available_assorted_track?
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
