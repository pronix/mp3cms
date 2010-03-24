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
      @track_downloads =  TopDownload.update_all(["count_downloads = ?", "0"] )
      if @track_downloads
        puts "Обнулены счетчики скачанных треков в количестве #{@track_downloads.size}"
      else
        puts "Счетчики статистики скачанных файлов не обнулены"
      end
    end
  end

end

