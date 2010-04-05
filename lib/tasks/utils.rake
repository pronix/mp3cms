# encoding: utf-8
namespace :mp3cms do

  namespace :users do
    desc "Removal unconfirmed accounts"
    task :remove_unconfirmed_accounts => :environment do
      @users =  User.inactive.destroy_all(["updated_at < ?", Settings[:account_activation_time].days.ago] )
      unless @users.blank?
        puts "Delete #{@users.size} users"
      else
        puts "Not found  users"
      end
    end
    desc "Разблокировка пользователей"
    task :unblock_accounts => :environment do
      @users = User.update_all("ban = #{false}, start_ban = null, end_ban = null, ban_reason = null ",
                               "ban = #{true} and end_ban < '#{Time.now.to_s(:db)}'")
      unless @users.blank?
        puts "Unblocked #{@users.size} users"
      else
        puts "Not found  users"
      end
    end
  end

  namespace :top_downloads do
    desc "Обнуление счетчиков статистики скачанный файлов"
    task :clear => :environment do
      @tracks = Track.active.update_all(["count_downloads = ?", "0"])
      if @tracks
        puts "Обнулены счетчики скачанных треков в количестве #{@tracks.size}"
      else
        puts "Счетчики статистики скачанных файлов не обнулены"
      end
    end
  end

  namespace :file_links do
    desc "Удаление просроченных временных ссылок на mp3 файлы"
    task :clear => :environment do
      @links = FileLink.destroy_all("expire < '#{Time.now.to_s(:db)}'")
      if @links
        puts "Временные ссылки просроченных временных ссылок на mp3 файлы удалены в количестве #{@links.size}"
      else
        puts "Временные ссылки просроченных временных ссылок на mp3 файлы не удалены"
      end
    end
  end

  namespace :archive_links do
    desc "Удаление просроченных временных ссылок на архивы файлов"
    task :clear => :environment do
      @links = ArchiveLink.destroy_all("expire < '#{Time.now.to_s(:db)}'")
      if @links
        puts "Временные ссылки просроченных временных ссылок на архивы файлов удалены в количестве #{@links.size}"
      else
        puts "Временные ссылки просроченных временных ссылок на архивы файлов не удалены"
      end
    end
  end

end

