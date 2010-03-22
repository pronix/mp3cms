require 'open-uri'
class Admin::CostCountriesController < Admin::ApplicationController
  filter_access_to :all, :attribute_check => false
  inherit_resources
  defaults :resource_class => CostCountry,
           :collection_name => 'cost_countries', :instance_name => 'cost_country'
  belongs_to :gateway
  respond_to :html, :js

  def new
    doc = Nokogiri::XML open(parent.url).read
    @countries = doc.xpath("//slab").map {|x| [x['country_name'], x['country']  ] }.uniq
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
    doc = Nokogiri::XML open(parent.url).read
    @countries = doc.xpath("//slab").map {|x| [x['country_name'], x['country']  ] }.uniq
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
end
