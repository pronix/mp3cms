 user_role = Role.find_or_create_by_name "user"
 if user_role
   User.all.each { |u| u.add_role user_role.name.to_sym }
 end

 admin_role = Role.find_or_create_by_name "admin"
 admin_user = User.find_by_email "mp3cms@gmail.com"
 admin_user.add_role admin_role.name.to_sym


