class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.string :href
      t.integer :shortner_id

      t.timestamps
    end
    add_index :items, :shortner_id
  end
end
