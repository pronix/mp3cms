Paperclip.interpolates :fileseparator do |attachment, style|
  require 'md5'
  attachment.instance.fileseparator ||= MD5.new(attachment.instance.title).to_s[0..2]
  attachment.instance.fileseparator
end
