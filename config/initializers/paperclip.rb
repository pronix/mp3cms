Paperclip.interpolates :fileseparator do |attachment, style|
    attachment.instance.username[0..2]
end
