class CreateSchemaSeeding < ActiveRecord::Migration[7.0]
  def change
    create_table :schema_seedings do |t|
      t.string :version, null: false
      t.timestamps
    end

    add_index :schema_seedings, :version, unique: true
  end
end
