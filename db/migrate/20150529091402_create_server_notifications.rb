class CreateServerNotifications < ActiveRecord::Migration
  def change
    create_table :server_notifications do |t|

      t.belongs_to :server, index: true
      t.belongs_to :notification, index: true
      t.integer    :fail_to_notify_count, null: false, default: 1
      t.timestamps null: false
    end
  end
end
