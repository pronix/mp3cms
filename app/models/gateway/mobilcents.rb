class Gateway::Mobilcents < Gateway

  preference :secret_code, :access_level => :edit   # секретный ключ
  preference :mobilgate_id
  preference :xml_url, :default => "http://engine.mobilcent.com/xml2/gate/?/all",
  :access_level => :edit
  validates_presence_of :secret_code, :mobilgate_id

  def helper_result_url
    "result_mobilcents_url"
  end
  def helper_status_url
    "status_pay_mobilcents_url"
  end

  def provider_class
    self.class
  end

  def url
    xml_url.gsub('?',mobilgate_id.to_s)
  end

  def tariffs
    Rails.cache.fetch("cache_tariffs") {
      @tariffs = {}
      HTTParty.get(self.url, :format => :xml)["feed"]["slab"].each do |item|
        @tariffs[item["country"].to_sym] ||= { :country_name => item["country_name"], :providers => { } }
        if item["provider"].blank?
          @tariffs[item["country"].to_sym][:providers][:default] ||= {:name => "default", :sms_price => [] }
          @tariffs[item["country"].to_sym][:providers][:default][:sms_price] << {
            :price    => item["price"],  :prefix   => item["prefix"],
            :number   => item["number"], :currency => item["currency"],
            :profit => item["profit"],
            :message  => "#{item["prefix"]} #{self.mobilgate_id}",
            :usd => item["usd"]
          }
        else
          item["provider"].each do |provider|
            unless provider["code"].blank?
              @tariffs[item["country"].to_sym][:providers][provider["code"].to_sym] ||= { :name => provider["name"], :sms_price => []}
              @tariffs[item["country"].to_sym][:providers][provider["code"].to_sym][:sms_price] << {
                :price   => provider["price"],  :prefix => provider["prefix"],
                :number  => provider["number"], :currency => provider["currency"],
                :message => "#{provider["prefix"]} #{self.mobilgate_id}",
                :usd     => provider["usd"], :profit => provider["profit"]
              }
            end
          end
        end
      end

      @tariffs
    }
  end

end
