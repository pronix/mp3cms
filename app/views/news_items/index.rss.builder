xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "MP3KOZA.COM"
    xml.description " Новости на mp3koza.com"
    xml.link news_items_url(:format => :rss)

    for item in @news
      xml.item do
        xml.title item.header
        xml.description item.text
        xml.pubDate item.created_at.to_s(:rfc822)
        xml.link news_item_url(item.id)
      end
    end
  end
end

