# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'erubi'
gem 'pg'
gem 'puma'
gem 'rack-unreloader'
gem 'roda'
gem 'sequel'

group :development do
  gem 'pry'
  gem 'rerun'
  gem 'solargraph'
end

group :development, :test do
  gem 'dotenv'
  gem 'warning'
end

group :test do
  gem 'minitest'
  gem 'minitest-hooks'
end
