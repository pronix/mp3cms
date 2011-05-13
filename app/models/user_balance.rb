module UserBalance
  # Пополнение баланса пользователю
  # параметрах передаем комментарий,
  # можно передовать массив комментария, тогда размер массива будет означать сколько раз надо сделать начисление
  Profit.table_exists? &&
    (Profit.credit.map(&:code) - ["referrer_bonus"]).each do |m|
    define_method "credit_#{m}" do | _comment|
      @options = { :date_transaction => Time.now.to_s(:db), :type_payment => Transaction::INTERNAL,
        :type_transaction => Transaction::CREDIT, }

      self.transaction do
        @amount = Profit.find_by_code(m).amount
        [_comment].flatten.each do |cm|
          transactions.create!(@options.merge({ :kind_transaction => m, :amount => @amount, :comment => cm })).complete!
        end
      end

      reload
    end
  end


  # Проверка хватает ли пользователю денег на баланса для совершения покупки
  def can_buy(summa)
    errors.clear
    errors.add_to_base("Недостаточно денег") unless summa <= self.balance
    errors.blank?
  end

  # Проверяет может ли пользователь вывести деньги
  def can_withdraw(summa=self.balance)
    errors.clear
    errors.add_to_base("Недостаточно денег") unless summa <= self.balance
    errors.add_to_base("Сумма не должна быть меньше #{Profit.minimum_withdraw}") if summa < Profit.minimum_withdraw
    errors.blank?
  end
  alias :can_withdraw? :can_withdraw

  # Списание с баланса
  # параметрах передаем комментарий,
  # можно передовать массив комментария, тогда размер массива будет означать сколько раз надо сделать начисление
  # при списание баланса также начиляеться % по реферной программе
  # При начисление проводиться проверка баланса, если сумма баланса не позволяет сделать списание,
  # то возвращаеться false и записываем в ошибки сообщение что недостаточно денег
  Profit.table_exists? &&
    (Profit.debit.map(&:code) - ["referrer_bonus"]).each do |m|

    define_method "available_#{m}?" do
      can_buy(Profit.find_by_code(m).amount)
    end

    define_method "debit_#{m}" do | _comment|
      @options = { :date_transaction => Time.now.to_s(:db),
        :type_payment => Transaction::INTERNAL,
        :type_transaction => Transaction::DEBIT,
      }

      @amount = Profit.find_by_code(m).amount
      @ramount = Profit.find_by_code("referrer_bonus").try(:amount).to_i
      @referrer_bonus = (@amount*@ramount)/100.0

      return false unless can_buy(@amount*[_comment].flatten.size)

      self.transaction do

        [_comment].flatten.each do |cm|
          transactions.create!(@options.merge({ :kind_transaction => m, :amount => @amount, :comment => cm })).complete!
          unless referrer.blank?
            referrer.transactions.create!(@options.merge({ :type_transaction => Transaction::CREDIT,
                                                           :kind_transaction => "referrer_bonus",
                                                           :amount => @referrer_bonus,:comment => cm })).complete!
          end
        end
      end

      reload
    end
  end


end
