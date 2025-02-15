class Note < ApplicationRecord
  searchkick
  belongs_to :user
  belongs_to :reference, polymorphic: true


  def search_data
    {
      id:,
      title:,
      content:,
      reference:,
      reference_id:,
      user_id:,
      created_at:,
      updated_at:,
    }
  end

  def self.search_default(search_params, params, page = 1, build_where = true)
    params ||= {}
    params[:where] = params[:where].merge({ is_deleted: [false, nil] })

    SearchService.build(Note, search_params, {
      operator: 'and',
      page: page.nil? ? 1 : page,
      per_page: 30,
      smart_aggs: true,
      body_options: { track_total_hits: true },
      aggs: Note.agg_search_array
    }.merge(params), build_where || false)
  end

  def self.agg_search_array
    []
  end
end
