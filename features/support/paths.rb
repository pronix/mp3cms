module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /password_resets\b/
      new_password_reset_path
    when /главной странице сервиса/i
      root_path
    when /Регистрации/i
      signup_path
    when /login/i
      login_path
    when /the home\s?page/
      '/'
    when /the new roles page/
      new_roles_path

    when /the new users page/
      new_users_path


    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
