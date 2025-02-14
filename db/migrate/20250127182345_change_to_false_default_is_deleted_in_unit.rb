class ChangeToFalseDefaulIsDeletedInUni < ActiveRecord::Migration[7.1]
  def change
    change_column_null :units, :is_deleted, default: false
    change_column_null :participants, :is_deleted, default: false
  end
end