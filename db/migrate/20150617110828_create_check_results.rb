class CreateCheckResults < ActiveRecord::Migration
  def change
    create_table :check_results do |t|

      t.integer :server_id
      t.integer :check_id
      t.boolean :passed
      t.integer :total_satellites
      t.integer :ready_satellites
      t.string  :satellites_data
      t.timestamps null: false
    end

    add_index  :check_results, :passed
    add_column :checks,  :fail_count, :integer, default: 0
  end
end
