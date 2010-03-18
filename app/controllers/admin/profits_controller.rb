class Admin::ProfitsController < ApplicationController
  before_filter :require_user
  filter_access_to :all, :attribute_check => false

  def show
    @profits = Profit.all
  end
  def edit
    @profits = Profit.all
  end

  def update
    @profits = Profit.update(params[:profits].keys, params[:profits].values).reject { |p| p.errors.empty? }
    if @profits.empty?
      flash[:notice] = I18n.t("flash.profits.update.notice")
      redirect_to admin_profits_path
    else
      render :action => "edit"
    end
  end


end
