Given /в сервисе записана стоимости по умолчанию$/ do
  [:upload_track, :find_track,:add_news,
   :refferer_bonus,:download_track,:order_track,
   :assorted_track,:min_amount_payout  ].each { |x| Factory(x)}

  User.class_eval do

    (Profit.credit.map(&:code) - ["referrer_bonus"]).each do |m|
      define_method "credit_#{m}" do | _comment|
        @options = { :date_transaction => Time.now.to_s(:db), :type_payment => Transaction::INTERNAL,
          :type_transaction => Transaction::CREDIT, }

        @amount = Profit.find_by_code(m).amount
        [_comment].flatten.each do |cm|
          transactions.create!(@options.merge({ :kind_transaction => m, :amount => @amount, :comment => cm })).complete!
        end

        reload
      end
    end


    # Списание с баланса
    # параметрах передаем комментарий,
    # можно передовать массив комментария, тогда размер массива будет означать сколько раз надо сделать начисление
    # при списание баланса также начиляеться % по реферной программе
    # При начисление проводиться проверка баланса, если сумма баланса не позволяет сделать списание,
    # то возвращаеться false и записываем в ошибки сообщение что недостаточно денег
    (Profit.debit.map(&:code) - ["referrer_bonus"]).each do |m|
      define_method "debit_#{m}" do |_comment|
        @options = { :date_transaction => Time.now.to_s(:db),
          :type_payment => Transaction::INTERNAL,
          :type_transaction => Transaction::DEBIT,
        }

        @amount = Profit.find_by_code(m).amount
        @referrer_bonus = (@amount*Profit.find_by_code("referrer_bonus").amount)/100.0

        return false unless can_buy(@amount*[_comment].flatten.size)

        [_comment].flatten.each do |cm|
          transactions.create(@options.merge({ :kind_transaction => m, :amount => @amount, :comment => cm })).complete!
          unless referrer.blank?
            referrer.transactions.create(@options.merge({ :type_transaction => Transaction::CREDIT,
                                                          :kind_transaction => "referrer_bonus",
                                                          :amount => @referrer_bonus,:comment => cm })).complete!
          end
        end

        reload
      end
    end


  end

end

When /^(?:|я )изменил поле стомости "([^\"]*)" для "([^\"]*)" на "([^\"]*)"$/ do |field, param, value|
  _param = Profit.find_by_name param.strip
  fill_in("profits[#{_param.id}][#{field}]", :with => value)
end

Given /^the following profits:$/ do |profits|
  Profit.create!(profits.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) profits$/ do |pos|
  visit profits_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following profits:$/ do |expected_profits_table|
  expected_profits_table.diff!(tableish('table tr', 'td,th'))
end

