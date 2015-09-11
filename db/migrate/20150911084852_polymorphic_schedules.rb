class PolymorphicSchedules < ActiveRecord::Migration
  def change
    add_column :notifications_schedules, :schedulable_id, :integer
    add_column :notifications_schedules, :schedulable_type, :string
    add_index :notifications_schedules, :schedulable_id
  end
end
