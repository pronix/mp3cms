Если /^я отправлю в корзину следующие треки:$/ do |table|
  table.hashes.each do |hash|
    user = current_user
    track = Track.find_by_title hash["Название"]
    cart_track = CartTrack.create!(:user_id => user.id, :track_id => track.id)
  end
end

