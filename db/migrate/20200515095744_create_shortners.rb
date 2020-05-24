class CreateShortners < ActiveRecord::Migration[5.2]
  def change
    create_table :shortners do |t|
      t.string :url
      t.integer :user_id

      t.timestamps
    end
    add_index :shortners, :url
    add_index :shortners, :user_id
  end
end
