class AddFieldsInParticipants < ActiveRecord::Migration[7.1]
  def change
    add_column :participants, :company_name, :string
    add_column :participants, :document, :string
    add_column :participants, :taxation_regime, :integer
    add_column :participants, :invoicing, :string
    add_reference :participants, :unit, foreign_key: true
    add_reference :participants, :contact, foreign_key: true

  end
end
