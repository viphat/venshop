source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use MySQL
gem 'mysql2'

# Use Twitter's Bootstrap
gem 'bootstrap-sass', '~> 3.3.7'

# Load Enviroment (Global) Variables from yml
gem 'figaro'

# Load Items from Amazon Product Advertising API
gem 'vacuum'

# File attachment library for ActiveRecord
gem "paperclip", "~> 5.0.0"

# Pagination
gem 'kaminari'
gem 'bootstrap-kaminari-views'

# Encapsulate parts of your UI into components
gem "cells-rails"
gem "cells-erb"

# Menu Breadcumbs
gem "breadcrumbs_on_rails"

# Authentication
gem 'devise'

# Authorization
gem 'pundit'

# Enumerize (using string instead of Number as Enum Type on Rails)
gem 'enumerize'

group :development, :test do
  gem 'pry-rails'
  gem 'pry-byebug'

  # RSpec
  gem 'rspec-rails'
end

group :test do

  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 3.1'

end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Better Errors
  gem "better_errors"
  gem "binding_of_caller"

  # Check N+1 Queries
  gem 'bullet'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
