class Contact < ApplicationRecord
  searchkick
  has_many :addresses, as: :reference, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true

  def search_data
    {
      name:,
      email:,
      mobile_phone:,
      position:,
      created_at:,
      updated_at:,
    }
  end

  def self.search_default(search_params, params, page = 1, build_where = true)
    params ||= {}
    params[:where] = params[:where].merge({ is_deleted: [false, nil] })

    SearchService.build(Contact, search_params, {
      operator: 'and',
      page: page.nil? ? 1 : page,
      per_page: 30,
      smart_aggs: true,
      body_options: { track_total_hits: true },
      aggs: Contact.agg_search_array
    }.merge(params), build_where || false)
  end

  def self.agg_search_array
    []
  end
end
