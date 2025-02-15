class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes do |t|
      t.string :title
      t.text :content
      t.string :reference_type
      t.integer :reference_id
      t.references :user, null: false, foreign_key: true
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
