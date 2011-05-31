module UserSearch
  def search_user(query, per_page = 10)
    return [] if query[:q].blank?
    @q = Riddle.escape(query[:q].to_s)
    @opt = { :per_page => per_page, :page => query[:page] }
    case query[:attribute].to_s
    when "id"
      where(:id => @q.split(/\ |,|\./).select(&:present?)).paginate(@opt)
    when /login|email/
      self.search( @opt.merge( { :conditions => { query[:attribute].to_sym => @q }} ))
    when "ip"
      self.search "@(last_login_ip,current_login_ip) #{@q}", :match_mode => :extended
    when "balance"
      self.search( @opt.merge( {:conditions => { :webmoney_purse => @q }} ) )
    else
      self.search @q, @opt
    end
  end

end
