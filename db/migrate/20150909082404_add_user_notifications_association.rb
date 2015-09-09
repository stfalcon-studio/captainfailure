class AddUserNotificationsAssociation < ActiveRecord::Migration
  def change
    add_column :notifications, :user_id, :integer
  end
end
