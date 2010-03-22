require 'open-uri'
class CostCountry < ActiveRecord::Base
  belongs_to :gateway
  validates_uniqueness_of :code, :scope => :gateway_id
  validates_presence_of :cost
  before_save :set_country
  def set_country
    # if self.changed.include? 'code'
      doc = Nokogiri::XML open(gateway.url).read
      self.country = doc.xpath("//slab").map {|x| x['country_name'] if x['country'] == self.code }.compact.first
    # end
  end
end
