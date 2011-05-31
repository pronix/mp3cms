class TagCloud < ActiveRecord::Base
  # TagCloud.generate
  def self.generate
    Lastsearch.delete_old_rows
    @last_searhes = Lastsearch.for_tag_cloud
    if @last_searhes # Допустим num = 20..100
      @max_num = @last_searhes.first["count_items"].to_i
      @min_num = @last_searhes.last["count_items"].to_i

      TagCloud.delete_all # Очищаем таблину от текущих тегов.
      @last_searhes.each do |item|

        font_size = (( item["count_items"].to_i / @max_num.to_f) * (4 - 1)).round # Взято из плагина https://github.com/mbleigh/acts-as-taggable-on

        TagCloud.create(:font_size      => font_size,
                        :url_string     => item["url_string"],
                        :url_attributes => item["url_attributes"],
                        :url_model      => item["url_model"])


      end
    end

  end

end


