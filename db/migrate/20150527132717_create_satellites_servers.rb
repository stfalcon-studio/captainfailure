class CreateSatellitesServers < ActiveRecord::Migration
  def change
    create_table :satellites_servers, id: false do |t|
      t.integer :satellite_id
      t.integer :server_id
    end
  end
end
