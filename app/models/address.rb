class Address < ApplicationRecord
  belongs_to :city

  validates :street, presence: true
  validates :number, presence: true
  validates :neighborhood, presence: true
  validates :zip_code, presence: true
end
