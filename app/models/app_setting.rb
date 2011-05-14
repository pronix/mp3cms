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
  default_scope :order => "created_at"
  class << self
    def top_users
      (find_by_code(:top_users) ||
       create(:code => "top_users",
              :name => "Сколько пользователей выводить в топе",
              :value => 7)).value.to_i
    end

    def method_missing(method, *args)
      if (parametr = first(:conditions => { :code => method.to_s }))
        return parametr.value
      else
        super(method, *args)
      end
    end

  end
end
