class AddTimeoutToChecks < ActiveRecord::Migration
  def change
    add_column :checks, :timeout, :integer, :default => 30
  end
end
