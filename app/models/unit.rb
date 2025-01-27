class Unit < ApplicationRecord
  searchkick
  belongs_to :contact, optional: true
  has_many :addresses, as: :reference, dependent: :destroy
  accepts_nested_attributes_for :addresses, allow_destroy: true

  enum status: { active: 0, inactive: 1 }

  def search_data
    {
      name:,
      cnpj:,
      success_percentage:,
      royalts:,
      contact_id:,
      contact_name: contact&.name,
      status:,
      is_deleted:,
      created_at:,
      updated_at:,
    }
  end

  def self.search_default(search_params, params, page = 1, build_where = true)
    params ||= {}
    params[:where] = params[:where].merge({ is_deleted: [false, nil] })

    SearchService.build(Unit, search_params, {
      operator: 'and',
      page: page.nil? ? 1 : page,
      per_page: 30,
      smart_aggs: true,
      body_options: { track_total_hits: true },
      aggs: Unit.agg_search_array
    }.merge(params), build_where || false)
  end

  def self.agg_search_array
    %w[cnpj name]
  end
end
