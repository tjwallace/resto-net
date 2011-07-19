source 'http://rubygems.org'

gem 'rails', '3.0.6'

# Models
gem 'friendly_id', '~> 3.2.1'
gem 'globalize3'
gem 'graticule'

# Controllers
gem 'kaminari'

# Views
gem 'rdiscount'
gem 'haml-rails', :git => 'git://github.com/indirect/haml-rails.git'

# Routes
gem 'routing-filter'

# Lib
gem 'nokogiri'

group :development, :test do
  gem 'sqlite3-ruby', :require => 'sqlite3'
  gem 'rspec-rails', '>= 2.0.0.rc' # Rake
end

group :development do
  gem 'rails3-generators'
  gem 'sishen-rtranslate', :require => 'rtranslate' # Rake
end

group :test do
  gem 'shoulda'
  gem 'factory_girl_rails'
end

group :production do
  gem 'pg'
end
