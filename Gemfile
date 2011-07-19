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

group :development do
  gem 'sqlite3-ruby', :require => 'sqlite3'
end

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'rails3-generators'

  # Rake
  gem 'sishen-rtranslate', :require => 'rtranslate'

  # Test
  gem 'rspec-rails', '>= 2.0.0.rc'
  gem 'shoulda'
  gem 'factory_girl_rails'
end
