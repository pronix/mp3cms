xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "My Blog"
    xml.description "My Fantastic Blog"
    xml.link posts_url

    for item in @news
      xml.item do
        xml.title item.title
        xml.description item.content
        xml.pubDate item.created_at.to_s(:rfc822)
        xml.link news_item(item)
      end
    end
  end
end

