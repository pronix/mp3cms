module TrackSearch

  # ищем по автору и титлу - at
  # передаем хеш query = q
  def search_at(q)
    Lastsearch.create_at(q_downcase(q[:q])) if q[:remember] != "no"
    search(q_downcase(q[:q]),  :match_mode => :extended,
           :conditions => { :state => "active" },
           :per_page => q[:per_page], :page => q[:page], :star => true)
  end

  def search_a(q)
    Lastsearch.create_at(q_downcase(q[:q]), 'a') if q[:remember] != "no"
    search(:conditions => { :author => q_downcase(q[:q]), :state => "active" },
           :per_page => q[:per_page], :page => q[:page], :star => true)
  end

  def search_t(q)
    Lastsearch.create_at(q_downcase(q[:q]),'t') if q[:remember] != "no"
    search(:conditions => { :title => q_downcase(q[:q]), :state => "active" },
           :per_page => q[:per_page], :page => q[:page], :star => true)
  end

  def q_downcase(q)
    Riddle.escape(q.to_s.mb_chars.downcase)
  end

  def user_search_track(query, per_page=20)
    query[:per_page] ||= per_page
    query[:page] ||= 1

    unless query.has_key?(:char)
      unless query[:q].blank?

        # почемуто не работает :star => true  - судя по логам даже запрос не идет
        query[:q] = query[:q].to_s.mb_chars.downcase.gsub('*','')

        if query[:everywhere] == "yes" || (query[:title] == "yes" && query[:author] == "yes")
          search_at(query)
        elsif query[:title].to_s == "yes"
          search_t(query)
        elsif query[:author].to_s == "yes"
          search_a(query)
        end
      else
        []
      end
    else
      query[:char] = query[:char].to_s.mb_chars.gsub(/\*|\^/,'')
      search("^#{q_downcase(query[:char])}*", :conditions => { :state => "active" },  :per_page => query[:per_page], :page => query[:page])
    end
  rescue
    [ ]
  end

  # Поиск из раздела админа
  #
  def search_track(query, per_page = 10)
    query_options = { :per_page => per_page, :page => query[:page], :star => true }
    @q = q_downcase(query[:q]) unless query[:q].blank?
    query_options[:conditions] = { :state  => query[:state] } if (query[:state] || "moderation").to_s =~ /active|moderation|banned/

    if query[:q].blank?
      search(query_options)
    else
      case query[:attribute]
      when "more"
        search(query_options.merge({ :with => { "data_file_size" => (query[:q].to_i.megabyte)..25000000 } }))
      when "less"
        search(query_options.merge({ :with => { "data_file_size" => 0..(query[:q].to_i.megabyte) } }))
      when "well"
        search(query_options.merge({ :with => { "data_file_size" => (query[:q].to_i.megabyte)..(query[:q].to_i.megabyte) } }))
      when "everywhere"
        search(@q, query_options)
      when "author"
        search(query_options.deep_merge({ :conditions => { :author => @q } }))
      when "title"
        search(query_options.deep_merge({ :conditions => { :title => @q } }))
      when "id"
        where(:id => query[:q].split(/\ |,|\./).select(&:present?)).paginate(query_options)
      when "login"
        search("@(email,login) #{@q}", :match_mode => :extended, :star => true)
      else
        search(query_options.deep_merge({ :conditions => { "#{query[:attribute]}" => @q  } }))
      end

    end

  end

end
