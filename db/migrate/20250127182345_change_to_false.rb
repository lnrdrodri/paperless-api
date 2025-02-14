class ChangeToFalse < ActiveRecord::Migration[7.1]
  def change
    change_column_default :units, :is_deleted, from: nil, to: false
    change_column_default :participants, :is_deleted, from: nil, to: false
  end
end