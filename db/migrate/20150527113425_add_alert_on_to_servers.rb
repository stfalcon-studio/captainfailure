class AddAlertOnToServers < ActiveRecord::Migration
  def change
    add_column :servers, :alert_on, :integer, default: 0
  end
end
