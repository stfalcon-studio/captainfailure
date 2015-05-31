class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|

      t.integer :server_id
      t.integer :check_type
      t.integer :check_via
      t.integer :tcp_port
      t.integer :http_code
      t.string  :http_keyword
      t.string  :http_vhost
      t.timestamps null: false
    end
  end
end
