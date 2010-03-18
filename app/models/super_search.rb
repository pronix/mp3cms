class SuperSearch

  def self.search(serch_string, name_model, attribute, state)
    unless serch_string.nil?
      if serch_string.size > 0
        case attribute
          when "everywhere"
            name_model.classify.constantize.search serch_string
          when "ip"
            rez_by_last_login_ip = name_model.classify.constantize.search :conditions => { :last_login_ip => serch_string }
            rez_by_current_login_ip = name_model.classify.constantize.search :conditions => { :current_login_ip => serch_string}
            rez_search = rez_by_last_login_ip + rez_by_current_login_ip
            rez_search.uniq!
          when "id"
            name_model.classify.constantize.search :conditions => { :id => serch_string }
          else
            if state.size > 0 && state != "all"
              rez = name_model.classify.constantize.search :conditions => { "#{attribute}" => serch_string, "state" => state}

            else
              rez = name_model.classify.constantize.search :conditions => { "#{attribute}" => serch_string }
            end
          end
      else
        return "У вас пустой запрос"
      end
    end
  end

end

