class AddReferencesInContacts < ActiveRecord::Migration[7.1]
  def change
    add_column :contacts, :reference_type, :string
    add_column :contacts, :reference_id, :integer
  end
end
