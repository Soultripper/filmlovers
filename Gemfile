source 'https://rubygems.org'

#ruby '1.9.3', :engine => 'jruby', :engine_version => '1.7.12'
ruby '2.1.2'
gem 'rails', '3.2.15'

gem 'pg'
#gem 'activerecord-jdbcpostgresql-adapter', platform: :jruby

gem 'puma'
gem 'nokogiri'
# gem 'google_movies'
# gem 'unicorn'
gem 'omniauth-facebook'#, '1.4.0'
gem 'omniauth-netflix'
gem "omniauth-google-oauth2"
gem 'omniauth-vimeo'
gem 'omniauth-twitter'
gem 'koala'
gem 'rack-iframe'
gem 'log4r'
gem 'fb-channel-file'
gem 'pusher'
# gem 'turbolinks'
# gem 'bson_ext'
# gem 'jruby-win32ole', '~> 0.8.5'
gem 'mongo'
gem 'rest-client'
gem "mongoid"
gem 'newrelic_rpm', '3.5.6.55'
gem 'rabl'
#gem "eventmachine", "~> 1.0.3"
gem 'meta-tags', "~> 2.0.0", :require => 'meta_tags'
gem 'gravtastic'
gem 'sitemap_generator', require: false
gem 'devise'
gem 'figaro'
gem 'state_machine'
gem 'execjs'
gem 'simple_form'

#gem 'therubyrhino'  

gem 'kaminari' #for pagination
gem 'geocoder' # for postcode lookup
gem 'dalli'
gem 'memcachier'
gem 'netflix4r', require: false
gem 'carrierwave'
# gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem "mini_magick"#, require: false
gem "fog"
gem 'darstellung'
gem 'rapns'
# gem 'chronic'
gem 'unf'
#gem 'curb'
# gem 'zipruby'


gem 'foreigner', require: false
# gem 'activerecord-postgres-hstore'
gem 'activerecord-postgres-array', '0.0.10'
# gem "jruby-activerecord-postgres-array", git: 'https://github.com/dalton/jruby-activerecord-postgres-array.git'
# Gems used only for assets and not required
# in production environments by default.
gem 'bugsnag'
gem 'rack-block'

group :assets do
  gem 'jquery-rails'#, '2.1.4'
  gem 'sass-rails',   '~> 3.2.3'
  # gem 'coffee-rails', '~> 3.2.1'
  # gem 'compass-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'masonry-rails'
  gem 'remotipart', '~> 1.2'
  # gem 'turbolinks'

  # gem 'therubyracer', :platforms => :ruby
  # gem 'libv8', '~> 3.11.8'  # Update version number as needed
end

group :test do
  # gem 'turn', require: false # SR - for pretty test output 
  # gem 'minitest' # SR - test suite for benchmarks
  gem 'mocha', require: false
end

group :development, :test do
  # gem 'ruby-prof' # SR - for profiling / benchmarking
  gem "awesome_print"
  # gem 'better_errors'
 # gem "binding_of_caller"
  # gem "letter_opener"
gem 'pry-rails'
end
