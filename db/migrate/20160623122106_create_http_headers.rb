class CreateHttpHeaders < ActiveRecord::Migration
  def change
    create_table :http_headers do |t|
      t.integer :check_id
      t.string :name, null: false
      t.string :value, null: false
      t.timestamps null: false
    end
  end
end
