class CreatePermissions < ActiveRecord::Migration[6.0]
  def change
    create_table :permissions do |t|
      t.string :name
      t.string :description
      t.string :action 
      t.boolean :is_deleted, default: false
      t.timestamps
    end
  end
end
