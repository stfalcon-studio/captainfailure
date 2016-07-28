class AddDaysLeftToChecks < ActiveRecord::Migration
  def change
    add_column :checks, :days_left, :integer, default: nil
  end
end
