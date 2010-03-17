xml.instruct! :xml, :version => "1.0"
xml.rss(:version => 2.0, "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title "title"
    xml.description "description"
    xml.link news_items_url(:format => :rss)

    for item in @news
      xml.item do
        xml.title item.header
        xml.description item.text
        xml.pubDate item.created_at.to_s(:rfc822)
        xml.link(:rel => 'alternate', :type => 'text/html', :href => news_item_path(item))
      end
    end
  end

end

