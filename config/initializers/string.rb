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

end

