class AddColumnsToCheck < ActiveRecord::Migration
  def change
    add_column :checks, :icmp_count, :integer, default: 5
    add_column :checks, :http_uri, :string
    add_column :checks, :http_protocol, :integer, default: 0
  end
end
