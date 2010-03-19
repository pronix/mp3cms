class Admin::PayoutsController < Admin::ApplicationController
  filter_access_to :all, :attribute_check => false
  inherit_resources
  defaults :resource_class => Transaction,
           :collection_name => 'transactions', :instance_name => 'transaction'
  respond_to :html, :js
  actions :index, :show, :create

  def create
    params[:type_action] &&
      case params[:type_action]

      when /generate_file/
        @result = Gateway.webmoney.masspay(params[:withdraw_ids])
        if @result.third.blank?
          send_data(@result.first,@result.second.merge({ }))
        else
          flash[:error] = ["<ul>",@result.third.map{|x| "<li>#{x}</li>" }, "</ul>"].flatten.join()
          redirect_to :action => :index
        end

      when /success_claim/
        @messages = Transaction.masspay_success!(params[:withdraw_ids])
        flash[:error] = ["<ul>",@messages[:error].map{|x| "<li>#{x}</li>" }, "</ul>"].flatten.join() unless
                         @messages[:error].blank?
        flash[:notice] = ["<ul>",@messages[:notice].map{|x| "<li>#{x}</li>" }, "</ul>"].flatten.join() unless
                         @messages[:notice].blank?
        redirect_to :action => :index
      end

  end

  private
  def collection
    @collection ||= Transaction.withdraws.open
  end
end
