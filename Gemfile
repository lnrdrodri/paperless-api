source "https://rubygems.org"

ruby "3.3.0"

gem "rails", "~> 7.1.3", ">= 7.1.3.4"

gem 'pg', '~> 1.1'

gem "puma", ">= 5.0"

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bootsnap", require: false

gem "rack-cors"
gem 'figaro'

gem 'elasticsearch'
gem 'searchkick', '5.2.1'

gem 'bcrypt'

gem 'jwt'

gem 'jbuilder', '~> 2.7'

group :development do
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem 'rswag-api'
  gem 'rswag-ui'
  gem 'rswag-specs'
  # gem 'parallel_tests'
  # gem 'rswag-specs'
  # gem 'rubocop-rspec'
end

