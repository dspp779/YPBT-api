# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.1'

gem 'econfig'
gem 'json'
gem 'puma'
gem 'sinatra'

gem 'YPBT', '~> 0.2.8'
gem 'dry-container'
gem 'dry-monads'
gem 'dry-transaction'
gem 'multi_json'
gem 'roar'
gem 'ruby-duration', '~> 3.2', '>= 3.2.3'
gem 'sequel'

group :development, :test do
  gem 'pry-byebug'
  gem 'sqlite3'
end

group :test, :production do
  gem 'rake'
end

group :development do
  gem 'rerun'

  gem 'flay'
  gem 'flog'
  gem 'rubocop'
end

group :test do
  gem 'minitest'
  gem 'minitest-rg'

  gem 'rack-test'

  gem 'vcr'
  gem 'webmock'
end

group :production do
  gem 'pg'
end

group :development, :production do
  gem 'hirb'
  gem 'tux'
end
