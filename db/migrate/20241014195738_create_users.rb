class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, default: ''
      t.string :email, null: false, default: '', unique: true
      t.string :password_digest, null: false, default: ''
      t.boolean :persist_session, default: false
      t.boolean :is_deleted, default: false


      t.timestamps
    end
  end
end
