source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '~> 3.2.x'

#gem 'less-rails'

gem 'virtus', :git => 'git://github.com/solnic/virtus.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'foundation-rails'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'execjs'
  gem 'therubyracer', '~> 0.10.2'

  gem 'backbone-rails'

  gem 'uglifier', '>= 1.0.3'
end

gem 'draper'
gem 'impressionist'
gem 'geocoder'
#gem 'mustache-rails', :require => 'mustache/railtie', :git => 'http://github.com/liaden/mustache-rails.git'

# caching
gem 'memcachier'
gem 'dalli'

gem 'authlogic'
gem 'friendly_id'

gem 'jquery-rails'

gem 'twitter'
gem 'tumblr4r'

gem 'paperclip'
gem 'aws-s3'
gem 'aws-sdk'
gem "active_attr"
gem "active_enum"

# replacement for lack of autolink in rails 3.1+
gem 'rails_autolink'

# payment system
gem 'stripe'

group :development, :test do
    gem 'rspec-rails'
    gem 'watchr'
    gem 'factory_girl_rails'
end

gem 'pg'

group :test do
    gem 'simplecov'
    gem 'capybara'
    gem 'selenium-webdriver'
    gem 'guard-rspec'
    gem 'launchy'
    gem 'faker'
    gem 'database_cleaner'
    gem 'sqlite3-ruby'
end

# use thin server instead of WEBrick
if RUBY_PLATFORM =~ /(win|w)32$/
  gem "eventmachine", "~> 1.0.0.beta.4.1"
else
  gem "eventmachine"
end

gem "thin"

