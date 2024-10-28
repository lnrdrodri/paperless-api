class Address < ApplicationRecord
  belongs_to :city

  validates :street, presence: true
  validates :number, presence: true
  validates :neighborhood, presence: true
  validates :zip_code, presence: true


  def address_attribute
    state = city.state
    country = state.country

    {
      city_id: city_id,
      state_id: state.id,
      country_id: country.id,
      state_name: state.name,
      country_name: country.name
    }
  end
end
