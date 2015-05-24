class CreateSatellites < ActiveRecord::Migration
  def change
    create_table :satellites do |t|

      t.string :name
      t.string :description
      t.timestamps null: false
    end
  end
end
