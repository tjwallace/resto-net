source 'http://rubygems.org'

gem 'rails', '3.0.19'

# Models
gem 'friendly_id', '~> 3.2.1'
gem 'graticule'
gem 'texticle', '~> 2.0', :require => 'texticle/rails'
gem 'unicode_utils'
gem 'rest-client'
gem 'yajl-ruby', :require => 'yajl'

# Controllers
gem 'kaminari'

# Views
gem 'rdiscount'
gem 'haml-rails'

# Routes
gem 'routing-filter'

# Rake
gem 'nokogiri'

group :development, :test do
  gem 'thin'
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'rspec-rails', '>= 2.0.0.rc' # Rake
end

group :development do
  gem 'rails3-generators'
end

group :test do
  gem 'shoulda'
  gem 'factory_girl_rails'
end

group :production do
  gem 'pg'
end
