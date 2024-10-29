class Permission < ApplicationRecord
  searchkick word_start: [:id]

  def search_data
    {
      id:,
      name:,
      description:,
      action:,
      is_deleted: is_deleted,
      created_at:,
      updated_at:
    }
  end

  def self.search_default(search_params, params, page = 1, build_where = true)
    params ||= {}
    params[:where] = params[:where].merge({ is_deleted: [false, nil] })

    SearchService.build(Permission, search_params, {
      operator: 'and',
      page: page.nil? ? 1 : page,
      per_page: 30,
      smart_aggs: true,
      body_options: { track_total_hits: true },
      aggs: Permission.agg_search_array
    }.merge(params), build_where || false)
  end

  def self.agg_search_array
    %i[name description action]
  end
end