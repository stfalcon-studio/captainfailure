class AddNewValuesToChecks < ActiveRecord::Migration
  def change
    add_column :checks, :enabled, :boolean, default: true
    add_column :checks, :check_interval, :integer, default: 5
  end
end
