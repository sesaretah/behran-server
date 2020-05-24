class AddIndexesToModels < ActiveRecord::Migration[5.2]
  def change
    add_index :profiles, :user_id
    
    add_index :roles, :user_id
     
    add_index :tags, :user_id
    
    add_index :notifications, :source_user_id
    add_index :notifications, :notifiable_id
    add_index :notifications, :notifiable_type
    add_index :notifications, :notification_type
    

    add_index :devices, :user_id
  end
end
