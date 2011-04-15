require 'iconv'
require 'UniversalDetector'

class String

  def to_utf8
    target_encoding = "UTF-8"
    begin
      detect_encoding = UniversalDetector::chardet(self)
      source_encoding = detect_encoding["encoding"].to_s

      # Если определилась как кодировка тип MacCyrillic и доверие не 1 то выставляем WINDOW-1251
      #
      source_encoding = 'WINDOWS-1251' if source_encoding =~ /CYRILLIC/i && detect_encoding['confidence'] < 1

      if target_encoding == source_encoding
        return self
      else
        return Iconv.iconv(target_encoding, source_encoding, self).to_s
      end
    rescue => e
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

