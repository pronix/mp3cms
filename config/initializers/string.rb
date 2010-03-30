require 'iconv'
require 'UniversalDetector'

class String

  def to_utf8
    target_encoding = "UTF-8"
    begin
      source_encoding = UniversalDetector::chardet(self)["encoding"].to_s
      reencoded_string = Iconv.iconv(target_encoding, source_encoding, self).to_s
      if target_encoding == source_encoding
        return self
      else
        return reencoded_string
      end
    rescue
      "---------"
    end
  end

  def secret_link(ip)
    secret_string = Array.new(100){['0'..'9','a'..'z','A'..'Z'].map{|r| r.to_a}.flatten[rand(['0'..'9','a'..'z','A'..'Z'].map{|r| r.to_a}.flatten.size)]}.to_s
    generate_link = [ip, Time.now.to_i, secret_string].join.to_s.to_md5
    generate_link.to_s
  end

  def to_md5
    Digest::MD5.hexdigest(self)
  end

end

