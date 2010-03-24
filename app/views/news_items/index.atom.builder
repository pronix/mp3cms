 atom_feed(:tag_uri => "2008") do |feed|
   feed.title(t("views.news_items.index_atom.title"))
   feed.updated((@news.first.created_at))

   for item in @news
     feed.entry(item) do |entry|
       entry.title(item.title)
       entry.content(item.body, :type => 'html')

       entry.author do |author|
         author.name(t("views.news_items.index_atom.author"))
       end
     end
   end
 end

