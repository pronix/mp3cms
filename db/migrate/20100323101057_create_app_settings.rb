=begin rdoc
Таблица для хранения изменяемых параметров сервис
=end
class CreateAppSettings < ActiveRecord::Migration
  def self.up
    create_table :app_settings do |t|
      t.string :code, :null => false    # код по которому будет вызываться
      t.string :name, :null => false    # название параметра будет отображаться при редактирование
      t.string :value, :null => false   # значение параметра
      t.timestamps
    end
    add_index :app_settings, :code
  end

  def self.down
    remove_index :app_settings, :code
    drop_table :app_settings
  end
end
