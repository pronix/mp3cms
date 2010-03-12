# encoding: utf-8
namespace :mp3cms do

  # namespace :delet do
  desc "Removal unconfirmed accounts"
  task :remove_unconfirmed_accounts => :environment do
    @user =  User.inactive.destroy_all(["updated_at < ?", Settings[:account_activation_time].days.ago] )
    unless @users.blank?
      puts "Delete #{@users.size} users"
    else
      puts "Not found  users"
    end

  end

end
