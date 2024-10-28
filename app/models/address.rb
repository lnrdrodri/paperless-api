class Address < ApplicationRecord
  searchkick
  belongs_to :city

  validates :street, presence: true
  validates :number, presence: true
  validates :neighborhood, presence: true
  validates :zip_code, presence: true
  
    def search_data
      {
        street: street,
        number: number,
        neighborhood: neighborhood,
        zip_code: zip_code,
        city_id: city_id,
      }.merge(address_attribute)
    end


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

  def self.search_default(search_params, params, page = 1, build_where = true)
    params ||= {}
    params[:where] = params[:where].merge({ is_deleted: [false, nil] })

    SearchService.build(Address, search_params, {
      operator: 'and',
      page: page.nil? ? 1 : page,
      per_page: 30,
      smart_aggs: true,
      body_options: { track_total_hits: true },
      aggs: Address.agg_search_array
    }.merge(params), build_where || false)
  end

  def self.agg_search_array
    %i[city_id city_name state_id country_id state_name country_name]
  end
end
