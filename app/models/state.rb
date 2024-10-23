class State < ApplicationRecord
  belongs_to :country
  has_many :cities

  validates :name, presence: true
  validates :uf, presence: true
end
