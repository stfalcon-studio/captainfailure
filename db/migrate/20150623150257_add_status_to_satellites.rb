class AddStatusToSatellites < ActiveRecord::Migration
  def change
    add_column :satellites, :status, :boolean, :default => false
  end
end
