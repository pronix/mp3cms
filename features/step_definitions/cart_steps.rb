When /^выберу трек "([^\"]*)"$/ do |track_name|
  @tracks = Track.where(:title => track_name.to_s.split(",").map(&:strip))
  @tracks.each do |track|
    When %Q(я установлю флажок в "track_ids_#{track.id}")
  end
end

When /^я добавляю в корзину трек "([^\"]*)"$/ do |track_title|
  @track = Track.where(:title => track_title).first
  find(:css, "tr#track_#{@track.id} a.add-to-cart").click
end

When /^я отправлю в корзину следующие треки:$/ do |table|
  table.hashes.each do |hash|
    @track = Track.find_by_title hash["Название"].strip
    click_link("cart_track_#{@track.id}")
  end
end
