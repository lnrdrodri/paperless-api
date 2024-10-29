class CreateRole < ActiveRecord::Migration[7.1]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :description
      t.boolean :is_active, default: true
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
