require 'open-uri'
class Admin::CostCountriesController < Admin::ApplicationController
  filter_access_to :all, :attribute_check => false
  inherit_resources
  defaults :resource_class => CostCountry,
           :collection_name => 'cost_countries', :instance_name => 'cost_country'
  belongs_to :gateway
  respond_to :html, :js

  def new
    load_countries
    new!
  end

  def create
    create! do |success, failure|
      success.html {
        flash[:notice] = I18n.t("flash.cost_country.create.notice")
        redirect_to collection_path }
    end
  end

  def edit
    load_countries
    edit!
  end

  def update
    update! do  |success, failure|
      success.html {
        flash[:notice] = I18n.t("flash.cost_country.update.notice")
        redirect_to collection_path }
    end
  end

  def destroy
    destroy!(:notice => I18n.t("flash.cost_country.destroy.notice"))
  end

  private
  def load_countries
    Rails.cache.delete("cost_country_#{parent.id}")
    @countries = Rails.cache.fetch("cost_country_#{parent.id}"){
      doc = Nokogiri::XML open(parent.url).read
      doc.xpath("//slab").map {|x| [x['country_name'], x['country']]}.uniq.sort{ |v1,v2| v1.first <=> v2.first } rescue []
    }
  end
end
