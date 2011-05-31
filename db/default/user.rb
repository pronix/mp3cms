 user_role = Role.find_or_create_by_name "user"
 if user_role
   User.all.each { |u|
     u.roles << user_role
     u.create_ftp_account
   }
 end

 admin_role = Role.find_or_create_by_name "admin"
 admin_user = User.find_by_email( "mp3cms@gmail.com")
 admin_user.roles << admin_role

