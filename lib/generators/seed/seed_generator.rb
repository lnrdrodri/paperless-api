class SeedGenerator < Rails::Generators::Base
  source_root File.expand_path('templates', __dir__)

  argument :name, type: :string

  def create_seed_file
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    template 'seed.rb.tt', "db/seeds/#{timestamp}_#{name.underscore}.rb"
  end
end
