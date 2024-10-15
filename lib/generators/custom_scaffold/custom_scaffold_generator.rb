require 'rails/generators/named_base'
require 'rails/generators/active_record'

class CustomScaffoldGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration
  source_root File.expand_path('templates', __dir__)

  argument :attributes, type: :array, default: [], banner: 'field:type field:type'
  class_option :path, type: :string, default: nil, banner: 'path'
  
  def create_controller
    if options[:path]
      @modules = options[:path].split('/')
      @controller_class_name = @modules.map(&:camelize).join('::')
    else
      @controller_class_name = file_name.camelize
    end

    @strong_params = strong_params
    target_path = File.join("app/controllers", options[:path], "#{file_name.pluralize}_controller.rb")

    template "controller.rb.tt", target_path

    create_controller_spec
  end
   
  
  def create_model
    ensure_is_deleted

    @model_class_name = file_name.camelize
    target_path = File.join("app/models", "#{file_name}.rb")

    template "model.rb.tt", target_path
    migration_template 'migration.rb.tt', File.join('db/migrate', "create_#{file_name.pluralize}.rb")
    create_factory
  end

  def create_model_spec
    spec_dir = "spec/models/#{file_name}_spec.rb"
    template "model_spec.rb.tt", spec_dir
  end

  def create_controller_spec
    target_path = File.join("spec/requests", options[:path], "#{file_name.pluralize}_spec.rb")
  
    path_parts = options[:path].split('/')
    request_path = path_parts.map(&:underscore).join('/')
  
    template "controller_spec.rb.tt", target_path, { request_path: request_path }
  end

  def create_factory
    factory_file_path = File.join("spec/factories", "#{file_name.pluralize}.rb")
  
    template "factory.rb.tt", factory_file_path
  end
  

  def self.next_migration_number(dirname)
    if ActiveRecord::Migration.respond_to?(:current_version)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  private

  def ensure_is_deleted
    unless attributes.any? { |attr| attr.name == 'is_deleted' }
      attributes << Rails::Generators::GeneratedAttribute.new('is_deleted', :boolean)
    end
  end

  def attributes_with_type
    attributes.map do |lab_attr|
      begin
        name, type = lab_attr&.split(':')
      rescue StandardError
        name = lab_attr.name
        type = lab_attr.type
      end

      Rails::Generators::GeneratedAttribute.new(name, type.to_sym)
    end
  end

  def strong_params
    permitted_params = ""
  
    normal_params = []
    special_params = []
  
    attributes.each do |attribute|
      param_name = attribute.name
      type = attribute.type
  
      if type == :jsonb || type.to_s.start_with?('array')
        special_params << "#{param_name.to_s}: []"
      else
        normal_params << ":#{param_name}"
      end
    end
  
    permitted_params += normal_params.map(&:to_s).join(', ')
  
    if special_params.any?
      permitted_params += ', ' unless permitted_params.empty?
      permitted_params += special_params.join(', ')
    end
  
    "params.require(:#{file_name}).permit(#{permitted_params})"
  end

  def default_value_for(type)
    types = {
      'string' => "Faker::Name.name",
      'text' => "Faker::Lorem.paragraph",
      'integer' => "rand(1..100)",
      'float' => "rand(1.0..100.0)",
      'decimal' => "rand(1.0..100.0)",
      'datetime' => "Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)",
      'timestamp' => "Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)",
      'time' => "Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)",
      'date' => "Faker::Date.between(from: Date.today - 1, to: Date.today)",
      'jsonb' => "{}",

    }
    types[type.to_s]
  end
  
end
