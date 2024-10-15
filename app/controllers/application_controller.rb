class ApplicationController < ActionController::API
  def custom_params
    {
      where: where_params,
      order: order_params
    }
  end

  def where_params(base = false)
    where = {}
    where = base if base
    where = JSON.parse(params[:where]) if params[:where]
    filter = JSON.parse(params[:filter]) if params[:filter]
    filter&.to_a&.each do |field|
      where[field[0].to_s] = identify_type_params[field[1].class.to_s].call(field)
    end

    where.deep_symbolize_keys
  end

  def identify_type_params
    {
      'Hash' => ->(field) { return field[1] },
      'Integer' => ->(field) { return field[1] },
      'Array' => ->(field) { return { all: field[1] } },
      'String' => ->(field) { return { like: "%#{field[1].downcase}%" } }
    }
  end

  def order_params
    order = {}
    order = JSON.parse(params[:order]) if params[:order]
    order['created_at'] = 'desc' if params[:search] == '*' && order == {}
    order
  end
end
