class RenameSchedules < ActiveRecord::Migration
  def change
    rename_table :notifications_schedules, :schedules
  end
end
