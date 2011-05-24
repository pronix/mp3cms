class ChangeStateInOrder < ActiveRecord::Migration
  def self.up
    @orders = []
    Order.all.each do |v|
      @orders << {
        :id => v.id,
        :state => ( case v.state.to_s
                    when 'moderation'
                      0
                    when 'notfound'
                      1
                    when 'found'
                      2
                    when 'cancel'
                      3
                    else 0
                    end)
      }
    end
    remove_column(:orders, :state)
    add_column(:orders, :state, :integer, :default => 0)
    @orders.each do |v|
      @order =  Order.find(v[:id])
      @order.state = v[:state]
      @order.save(:validate => false)
    end
  end

  def self.down
    remove_column(:orders, :state)
    add_column(:orders, :state, :string)
  end
end
