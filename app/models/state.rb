class State < ApplicationRecord
  belongs_to :country
  has_many :cities

  validates :name, presence: true
  validates :iso, presence: true
end
