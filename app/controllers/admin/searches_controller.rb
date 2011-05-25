class Admin::SearchesController < ApplicationController
  filter_access_to :all, :attribute_check => false


  def show
    @partial = params[:model].pluralize
  end

  # Поиск в админке
  # если в запросе указана модель и строка поиска пустая и при этом это не поиск по транзакциям
  # то выводиться сообщение о пустом поиск
  # если в запросе указана модель и строка поиска пустая и при этом поиск по транзакции проверяеться чтоб дата была не пустая
  # В иных случаях выполняеться поиск по моделям со строкой поиска
  def search
    @partial = params[:model].pluralize
    if %w(user track news playlist transaction).include?(params[:model].to_s)
      @results = send :"search_#{params[:model].pluralize}"
    else
      @results = [ ]
    end

  end

  private

  def search_users
    User.search_user(params)
  end

  def search_tracks
    Track.search_track(params)
  end

  def search_news
    NewsItem.search_newsitem(params, per_page = 10, current_user)
  end

  def search_playlists
    Playlist.search_playlist(params)
  end

  def search_transactions
    Transaction.search_transaction(params)
  end

end

