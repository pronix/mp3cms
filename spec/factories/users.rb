Factory.define :user do |u|
  u.login "user"
  u.email "user@example.com"
  u.password "password"
  u.password_confirmation "password"
end

Factory.define :admin, :parent => :user do |a|
  a.login "admin"
  a.email "admin@example.com"
  a.roles {|factory| [factory.association(:admin_role)]}
  a.active true
end

Factory.define :active_user, :parent => :user do |u|
  u.active true
end


Factory.define :user_waiting_activation, :parent => :user do |u|
  u.active false
  u.perishable_token  "abcd"
end

Factory.define :user_requesting_password, :parent=>:user do |u|
  u.perishable_token  "abcd"
end

Factory.define :role do |r|
end

Factory.define :admin_role, :parent => :role do |r|
  r.name "admin"
  r.title "admin"
  r.system true
  r.admin true
  r.description "administrator"
end

Factory.define :user_role, :parent => :role do |r|
  r.name "user"
  r.title "user"
  r.system true
  r.admin false
  r.description "user"
end
Factory.define :moderator_role, :parent => :role do |r|
  r.name "moderator"
  r.title "moderator"
  r.system true
  r.admin false
  r.description "moderator"
end


