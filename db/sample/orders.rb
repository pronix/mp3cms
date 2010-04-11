#  require "populator"
#  require "faker"
#  # Добавляем категории новостей + новости в этих категориях + связи между новостяни и категориями
#
#    [Order, Tender].each(&:delete_all)
#
#    Order.populate 23 do |order|
#      order.author = Populator.words(1..2)
#      order.title = Populator.words(1..2)
#      order.floor = Populator.value_in_range(1..2)
#      order.language = Populator.value_in_range(1..9)
#      order.user_id = Populator.value_in_range(1..3)
#      order.music = Populator.value_in_range(1..3)
#      order.state = ["found", "notfound"]
#      order.more = Populator.words(10..20)
#
#      Tender.populate 10 do |tender|
#        tender.complete = [true, false]
#        tender.order_id = order.id
#        tender.user_id = Populator.value_in_range(1..3)
#        tender.link = Populator.words(10..20)
#      end
#  end
#
