class AddIndexToServers < ActiveRecord::Migration
  def change
    add_index :servers, :dns_name
    add_index :servers, :ip_address
  end
end
