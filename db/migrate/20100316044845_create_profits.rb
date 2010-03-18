class CreateProfits < ActiveRecord::Migration
  def self.up
    #  debit:     # списание денег
    # credit:     # пополнение баланса
    create_table :profits do |t|
      t.string     :name
      t.string     :code
      t.decimal    :amount, :precision => 10, :scale => 2, :null => false, :default => 0 # сумма
      t.boolean    :percentage, :null => false, :default => false  # указываем что сумма в процентах
      t.string    :type_transaction, :null => false # доход\расход
      t.timestamps
    end
  end

  def self.down
    drop_table :profits
  end
end
