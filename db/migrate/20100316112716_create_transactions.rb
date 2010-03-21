class CreateTransactions < ActiveRecord::Migration
  # debit:              # списание денег
  # credit:             # пополнение баланса
  def self.up
    create_table :transactions do |t|
      t.integer   :user_id,          :null => false    # пользователь
      t.datetime  :date_transaction, :null => false    # дата транзакции
      t.decimal   :amount, :precision => 10, :scale => 2, :null => false, :default => 0 # сумма
      t.string    :comment # комментарий

      t.string :kind_transaction  # вид операции (Покупка mp3...)
      t.integer  :type_payment      # тип операции внешний внутренний
      t.integer  :type_transaction  #  приход \расход (credit\debit)

      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
