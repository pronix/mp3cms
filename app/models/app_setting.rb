=begin rdoc
Изменяемые параметры приложения
  top_users        - "Сколько пользователей выводить в топе"
  period_earnings  - "Заработанная сумма за последние Х дней"
  add_files        - "Добавлено файлов за Х дней"
  top_tracks       - "Сколько треков выводить в топе"
  download_files   - "Скачано файлов за Х дней"

Для получения параметра вызваем AppSetting.top_users
=end

class AppSetting < ActiveRecord::Base
  validates_presence_of :code, :name, :value
  validates_uniqueness_of :code

  class << self
    def method_missing(method, *args)
      if (parametr = first(:conditions => { :code => method.to_s }))
        return parametr.value
      else
        super(method, *args)
      end
    end
  end
end
