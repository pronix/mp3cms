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

    [
     [:top_users,       7, "Сколько пользователей выводить в топе"],
     [:period_earnings, 7, "Заработанная сумма за последние Х дней"],
     [:add_files,       7, "Добавлено файлов за Х дней"],
     [:top_tracks,      7, "Сколько треков выводить в топе"],
     [:download_files,  7, "Скачано файлов за Х дней"]

    ].each do |m|
      define_method :"#{m.first}" do
        (find_by_code(m.first) || create(:code => "top_users", :name => m.last,   :value => m.second)).value.to_i
      end
    end

    # Для того чтоб этот метод не заходил в method_missing
    #
    def find_by_code(code)
      where(:code => code).first
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
