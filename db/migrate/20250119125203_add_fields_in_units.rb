class AddFieldsInUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :units, :success_percentage, :float
    add_column :units, :royalts, :integer
    add_reference :units, :contact, null: false, foreign_key: true
    
  end
end
