# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :check_blocking_ip
  before_filter :prepare_params
  before_filter :set_time_zone
  helper_method :save_tracks_to_session
  helper_method :available_tracks
  helper_method :get_sign_available_track

  # Обработка ошибок с кодировкой запросов postgresql
  #
  rescue_from ActiveRecord::StatementInvalid,PGError do |exception|
    rescue_invalid_encoding(exception)
  end

  # Обработка ошибок с кодировкой запросов postgresql
  #
  rescue_from ActionView::MissingTemplate do |exception|
    render "public/404.html"
  end

  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :current_user_session, :current_user
  before_filter :set_current_user
  before_filter :set_referrer
  before_filter :load_tenders

  def permission_denied

    flash[:error] = I18n.t(:permission_denied)
    redirect_to root_path
  end

  def page_options(count_per_page = 20)
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1
    @per_page = (Rails.env=='test' ? 4 : count_per_page).to_i
    { :per_page => @per_page, :page => @page }
  end

  def url_path
    request.path_parameters()
  end

  private

  def prepare_params
    if (params||{ }).has_key?(:page) && !(Hash === params[:page])
      params[:page] = (params[:page].to_i == 0 ? 1 : params[:page].to_i.abs)
    end
  end

  # Обработка плохих запросов: не та кодировка, левые данные
  #
  def rescue_invalid_encoding(exception)
    render "public/500.html", :status => :bad_request, :layout => false
  end


  # Установка referrer в сессию
  # Если пользователь не авторизован и
  # в урле есть параметр u(ид пользователя)
  # то записываем в сессию
  def set_referrer
    session[:referrer] = params[:u] if !current_user && !params[:u].blank?
  end

  def set_current_user
    Authorization.current_user = current_user
  end


  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && !current_user_session.record.ban? &&
      current_user_session.record
  end

  def require_user
    unless current_user
      store_location
        flash[:notice] = I18n.t(:require_user)
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = I18n.t(:require_no_user)
      redirect_to root_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def find_user
    @user = current_user
  end


  def load_tenders
    if current_user
      @tender_orders = current_user.tenders.new_tenders.map(&:order).uniq
    end
  end

  def clear_flash
    flash.keys.each { |k| flash.delete(k)}
  end

  def set_time_zone
    min = request.cookies["time_zone"].to_i
    Time.zone = ActiveSupport::TimeZone[min.minutes]
  end

  # Блокировка ip адреса
  #
  def check_blocking_ip
    render "public/blocking.html", :layout => nil if User.bans.ip_ban(request.ip).count > 0
  end

  # Сохраняем ид треков в сессии по уникальным хешам
  #
  def save_tracks_to_session(tracks)
    current_user ? (session[:available_tracks] ||= { }) : session[:available_tracks] = { }
    [ tracks.to_a ].flatten.each {|track| add_sign_available_track(track) }
    session[:available_tracks]
  end

  def available_tracks
    session[:available_tracks]
  end

  def get_sign_available_track(track)
    session[:available_tracks] ||={}
    session[:available_tracks].find{|k,v| v == track.id }.try(:first) || add_sign_available_track(track)
  end

  def add_sign_available_track(track)
    delete_track_from_session_if_exists(track)
    @salt = (1..10).map{ [ ('A'..'Z').to_a, ('a'..'z').to_a, (0..100).to_a ].flatten.sample }.join
    session[:available_tracks] ||= { }
    key = Digest::SHA1.hexdigest("#{@salt}--#{Time.now}--#{track.id}")[4..11]
    session[:available_tracks][key] = track.id
    key
  end

  def delete_track_from_session_if_exists(track)
    session[:available_tracks] ||= { }
    if session[:available_tracks].values.include?(track.id)
      key = session[:available_tracks].find{|k,v| v == track.id }.try(:first)
      session[:available_tracks].delete(key)
    end
  end

end

