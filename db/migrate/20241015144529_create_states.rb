class CreateStates < ActiveRecord::Migration[7.1]
  def change
    create_table :states do |t|
      t.string :name, null: false
      t.string :uf, null: false
      t.references :country, null: false
      
      t.timestamps
    end
  end
end
