class Gateway::Mobilcents < Gateway

  preference :secret_code, :access_level => :edit   # секретный ключ
  preference :mobilgate_id
  preference :xml_url, :default => "http://engine.mobilcent.com/xml2/gate/?/all",
                       :access_level => :edit
  validates_presence_of :secret_code, :mobilgate_id

  def provider_class
    self.class
  end

  def url
    xml_url.gsub('?',mobilgate_id.to_s)
  end
end
