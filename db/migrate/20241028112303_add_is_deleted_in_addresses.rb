class AddIsDeletedInAddresses < ActiveRecord::Migration[7.1]
  def change
    add_column :addresses, :is_deleted, :boolean, default: false
  end
end
