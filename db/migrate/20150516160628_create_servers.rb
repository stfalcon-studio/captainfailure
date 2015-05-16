class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|

      t.string :visible_name, null: false
      t.string :ip_address, null: false
      t.string :comment
      t.timestamps null: false
    end
  end
end
