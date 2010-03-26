class TagCloud < ActiveRecord::Base

  def self.generate
    Lastsearch.delete_old_rows
    rezs = Lastsearch.find(:all, :order => "num DESC", :limit => 21) # Допустим num = 20..100
    max = rezs.first.num                                         # max = 100
    min = rezs.last.num                                         # min = 20
    rang = (max - min) / 15                                      # 15, помежуток в пикселях между минимальним и максимальным шрифтом (100 - 20) делим на  15, получаем шаг одной позиции пикселя равный 5.3 единиц
    TagCloud.delete_all # Очищаем таблину от текущих тегов.
    for rez in rezs
      font_size = ((rez.num - min) / rang).to_i + 10             # Вычисляем размер шрифта 100 - 20 делим на 5.3 = 15 + 10 минимальный размер шрифта, и получаем шрифт равный 25px
      TagCloud.create(:font_size => font_size, :url_string => rez.url_string, :url_attributes => rez.url_attributes, :url_model => rez.url_model)
    end
  end

end

