
  def self.partials
    partials_with_attributes = {}
    dirs.map do |root|
      partials = partials_list(root)
      dir = dir_split(root)

      partials_with_attributes = make_hierarchical_structure(dir, 0, partials, partials_with_attributes)
    end

    partials_with_attributes
  end

  def self.make_hierarchical_structure(dirs, index = 0, partials, structure)
    return if index >= dirs.length - 1

    structure[dirs[index].to_sym] =
      make_hierarchical_structure(dirs, index + 1, partials, structure[dirs[index].to_sym] || {})

    structure[dirs[index].to_sym] = partials if structure[dirs[index].to_sym].nil?

    structure
  end

  def dirs
    Dir.glob('./swagger/v1/components/**/*.json')
  end

  def dir_split(root)
    root&.slice!('./swagger/v1/components/')
    root&.slice!('.json')
    root&.split('/')
  end

  def partials_list(root)
    JSON.parse(File.read(root))
  end

  def self.all_models_with_attributes
    models = ActiveRecord::Base.connection.tables.map do |model|
      model&.classify&.safe_constantize
    end
    models_with_attributes = {}
    models.each do |model|
      next if model.nil?

      models_with_attributes[model.to_s] = { type: 'object', properties: models_attributes(model) }
    end
    JSON.parse(models_with_attributes.to_json)
  end

  def self.models_attributes(model)
    response = {}
    model.attribute_names.each do |attr|
      response[attr.to_sym] = format_type[model.type_for_attribute(attr).type]
    end
    response
  end

  def self.format_type
    {
      integer: { type: 'string' },
      float: { type: 'number' },
      decimal: { type: 'number' },
      string: { type: 'string' },
      text: { type: 'string' },
      boolean: { type: 'boolean' },
      datetime: { type: 'string', format: 'date-time' },
      date: { type: 'string', format: 'date-time' },
      time: { type: 'string', format: 'date-time' },
      timestamp: { type: 'string', format: 'date-time' },
      binary: { type: 'string' },
      big_decimal: { type: 'string' },
      big_integer: { type: 'string' },
      serialized: { type: 'string' },
      uuid: { type: 'string' },
      json: { type: 'string' },
      jsonb: { type: 'string' },
      array: { type: 'array' },
      object: { type: 'object' }
    }
  end

  def self.partials
    partials_with_attributes = {}
    dirs.map do |root|
      partials = partials_list(root)
      dir = dir_split(root)
  
      partials_with_attributes = make_hierarchical_structure(dir, 0, partials, partials_with_attributes)
    end
  
    partials_with_attributes
  end

  def self.make_hierarchical_structure(dirs, index = 0, partials, structure)
    return if index >= dirs.length - 1
  
    structure[dirs[index].to_sym] =
      make_hierarchical_structure(dirs, index + 1, partials, structure[dirs[index].to_sym] || {})
  
    structure[dirs[index].to_sym] = partials if structure[dirs[index].to_sym].nil?
  
    structure
  end

  def dirs
    Dir.glob('./swagger/components/partials/v1/**/*.json')
  end
  
  def dir_split(root)
    root&.slice!('./swagger/components/partials/')
    root&.slice!('.json')
    root&.split('/')
  end
  
  def partials_list(root)
    JSON.parse(File.read(root))
  end


module ModelsHelper
  def partial_path
    file_path = caller_locations(1,1)[0].path
    partial_path = file_path.split('/spec/api/').last
    partial_path = partial_path.sub('_spec.rb', '')
    partial_name = "_#{partial_path.split('/').last.singularize}"

    "#/components/partials/#{partial_path}/#{partial_name}"
  end

  def aggregators
    file_path = caller_locations(1,1)[0].path
    partial_path = file_path.split('/spec/api/').last
    partial_path = partial_path.sub('_spec.rb', '')
    model_name = partial_path.split('/').last.singularize
  
    model = model_name.classify.constantize
    {
      type: :object,
      properties: model.agg_search_array.each_with_object({}) do |agg, properties|
        properties[agg] = {
          type: :object,
          properties: {
            meta: { type: :object },
            doc_count: { type: :integer },
            doc_count_error_upper_bound: { type: :integer },
            sum_other_doc_count: { type: :integer },
            buckets: {
              type: :array,
              items: agg.to_s.include?('_id') ? { type: 'integer' } : format_type[model.type_for_attribute(agg).type || :string]
            }
          }
        }
      end
    }
  end

  def format_type
    {
      integer: { type: 'integer' },
      float: { type: 'number' },
      decimal: { type: 'number' },
      string: { type: 'string' },
      text: { type: 'string' },
      boolean: { type: 'boolean' },
      datetime: { type: 'string', format: 'date-time' },
      date: { type: 'string', format: 'date-time' },
      time: { type: 'string', format: 'date-time' },
      timestamp: { type: 'string', format: 'date-time' },
      binary: { type: 'string' },
      big_decimal: { type: 'integer' },
      big_integer: { type: 'integer' },
      serialized: { type: 'string' },
      uuid: { type: 'string' },
      json: { type: 'string' },
      jsonb: { type: 'string' },
      array: { type: 'array' },
      object: { type: 'object' }
    }
  end

  def user_not_logged
    response '401', 'Unauthorized' do
      schema type: :object,
        properties: {
          message: { type: :string }
        },
        example: {
          message: 'User not logged'
        }

        run_test!
    end
  end
  
end