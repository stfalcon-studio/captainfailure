class CreateAvailabilityStats < ActiveRecord::Migration
  def change
    create_table :availability_stats do |t|
      t.integer :check_id
      t.float   :percent
      t.string  :day_for
      t.timestamps null: false
    end
  end
end
