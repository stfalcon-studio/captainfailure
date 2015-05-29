class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|

      t.integer :notification_type
      t.string  :value
      t.timestamps null: false
    end
  end
end
