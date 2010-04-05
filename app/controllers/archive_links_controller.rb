class ArchiveLinksController < ApplicationController

  before_filter :require_user
  before_filter :find_user

  def download
    # Качаем архив, смотреть lib/archive.rb
  end

end

