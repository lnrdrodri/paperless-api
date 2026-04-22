class City < ApplicationRecord
  searchkick word_start: %i[name]
  belongs_to :state

  validates :name, presence: true

  def search_data
    {
      name:,
      state_id: state_id,
    }
  end

  def self.search_default(search_params, params, page = 1, build_where = true)
    params ||= {}

    SearchService.build(City, search_params, {
      operator: 'and',
      page: page.nil? ? 1 : page,
      per_page: 20,
      smart_aggs: true,
      body_options: { track_total_hits: true },
      aggs: City.agg_search_array
    }.merge(params), build_where || false)
  end

  def self.agg_search_array
    %i[state_id]
  end
end
