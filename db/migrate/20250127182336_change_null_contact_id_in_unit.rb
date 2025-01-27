class ChangeNullContactIdInUnit < ActiveRecord::Migration[7.1]
  def change
    change_column_null :units, :contact_id, true
    change_column_null :participants, :contact_id, true
  end
end
