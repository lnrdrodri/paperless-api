class CreateUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :units do |t|
      t.string :name, null: false
      t.string :cnpj, null: false
      t.integer :status, default: 0
      t.boolean :is_deleted, default: true
      
      t.timestamps
    end
  end
end
