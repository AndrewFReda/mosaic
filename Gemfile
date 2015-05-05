source 'https://rubygems.org'

# General Rails gems
gem 'rails', '4.1.6'
gem 'pg'
gem 'bcrypt', '~> 3.1.7'
gem 'dotenv-rails', :groups => [:development, :test]

# Front End Gems
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'backbone-on-rails'
gem 'lodash-rails'
gem 'jquery-fileupload-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer'
gem 'autoprefixer-rails'

# Image proessing and upload
gem 'aws-sdk'
gem 'paperclip'
gem 'sidekiq'
gem 'fog'

# Code quality
gem 'rubocop'

# Not used yet
# gem 'omniauth'
# gem 'omniauth-facebook'
# gem 'unicorn'
# gem 'capistrano-rails', group: :development
# gem 'debugger', group: [:development, :test]

# Testing
group :test do
  gem 'rspec-rails'
  gem 'simplecov', :require => false
  gem 'factory_girl_rails'
  gem 'webmock'
  gem 'database_cleaner'
  #gem 'gaurd-rspec'
  #gem 'rb-fsevent'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. https://github.com/rails/spring
  gem 'spring'
  # Debugging
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'awesome_print'
  # Error Handling
  gem 'better_errors'
  gem 'binding_of_caller'
  # Misc
  gem 'lolcommits'
end

group :doc do
    # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0'
end