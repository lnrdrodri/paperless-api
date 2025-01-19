class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :mobile_phone
      t.string :position
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
