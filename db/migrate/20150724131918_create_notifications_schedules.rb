class CreateNotificationsSchedules < ActiveRecord::Migration
  def change
    create_table :notifications_schedules do |t|

      t.integer :notification_id
      t.string  :m
      t.string  :h
      t.string  :dom
      t.string  :mon
      t.string  :dow
      t.timestamps null: false
    end
  end
end
