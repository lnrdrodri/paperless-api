class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :reference_type, null: false
      t.integer :reference_id, null: false
      t.string :street, null: false
      t.string :number, null: false
      t.string :complement
      t.string :neighborhood, null: false
      t.string :zip_code, null: false
      t.references :city, null: false

      t.timestamps
    end
  end
end
