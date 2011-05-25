module TransactionSearch
  def search_transaction(query, per_page = 10)
    @tr_params = query[:transaction] || { }
    start_date = Date.new(@tr_params["start_date(1i)"].to_i, @tr_params["start_date(2i)"].to_i, @tr_params["start_date(3i)"].to_i)
    end_date   = Date.new(@tr_params["end_date(1i)"].to_i,   @tr_params["end_date(2i)"].to_i,   @tr_params["end_date(3i)"].to_i)
    @options = { :per_page => per_page, :page => query[:page] }

    case query[:attribute]
    when "type_transaction"
      search(@options.merge({ :conditions => { :type_transaction => @tr_params[:select_type_transaction] },
                              :with => { :date_transaction => start_date.to_time..end_date.to_time } }))
    when "webmoney_purs"
      case query[:webmoney_purs]
      when "more"
        search( @options.merge({ :with => {
                                   :date_transaction => start_date.to_time..end_date.to_time,
                                   :amount => query[:q].to_f..99999.to_f }
                               }))
      when "less"
        search( @options.merge({ :with => {
                                   :date_transaction => start_date.to_time..end_date.to_time,
                                   :amount => -99999.to_f..query[:q].to_f }
                               }))
      when "well"
        search(@options.merge({  :with => {
                                  :amount => query[:q].to_f..query[:q].to_f,
                                  :date_transaction => start_date.to_time..end_date.to_time }
                              }))
      end

    when "type_payment"
      search( @options.merge({ :conditions => { :type_payment => query[:transaction][:select_type_payment] },
                               :with => {:date_transaction => start_date.to_time..end_date.to_time }
                             }))

    when "login"
      search(@options.merge({ :conditions => { :user => query[:q] },
                              :with => {:date_transaction => start_date.to_time..end_date.to_time} }))
    else
      []
    end

  end

end
