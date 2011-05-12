class Admin::SearchesController < ApplicationController
  filter_access_to :all, :attribute_check => false



  # Поиск в админке
  # если в запросе указана модель и строка поиска пустая и при этом это не поиск по транзакциям
  # то выводиться сообщение о пустом поиск
  # если в запросе указана модель и строка поиска пустая и при этом поиск по транзакции проверяеться чтоб дата была не пустая
  # В иных случаях выполняеться поиск по моделям со строкой поиска
  def show
    @index = 0
    @partial = (!params[:model].blank? && params[:model][/playlist|news_item|user|transaction/]) ? params[:model] : "track"
    @rez_search =
      if params[:model] && params[:q].blank? && !(params[:model][/transaction/] && params[:transaction])
        unless params[:q].nil?
          flash.now[:notice] = 'У вас пустой запрос'
        end
        []
      else
        case params[:model]
        when "playlist"
          Playlist.search_playlist(params, per_page = 10)
        when "news_item"
          current_user.admin? ?
          NewsItem.search_newsitem(params, per_page = 10, current_user) : NewsItem.search_newsitem(params, per_page = 10)
        when "user"
          User.search_user(params, per_page = 10)
        when "transaction"
          Transaction.search_transaction(params, per_page = 10)
        else
          Track.search_track(params, per_page = 10)
        end
      end
  end


end

