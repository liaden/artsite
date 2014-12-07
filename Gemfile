source 'https://rubygems.org'

gem 'rails', '4.0'
gem 'authlogic', '~> 3.3.0'

gem 'activeadmin', :git => 'http://github.com/activeadmin/activeadmin'

# active admin requires devise which I am not using
# devise is not set up so we need to force it to not
# be required by default by rails so it is listed here
gem 'devise', :require => false 

gem 'virtus', :git => 'git://github.com/solnic/virtus.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'   
  gem 'foundation-rails'
  gem 'coffee-rails'
  gem 'sass'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'execjs'
  gem 'therubyracer', '~> 0.12.0'

  gem 'backbone-rails'
  gem 'foundation-icons-sass-rails'
  gem 'uglifier', '>= 1.0.3'
end

gem 'draper'
gem 'foundation_rails_helper'
gem 'best_in_place'


gem 'impressionist'
gem 'geocoder'
#gem 'mustache-rails', :require => 'mustache/railtie', :git => 'http://github.com/liaden/mustache-rails.git'

# caching
gem 'memcachier'
gem 'dalli'

gem 'friendly_id'

gem 'jquery-rails'
gem 'jquery-ui-rails'

gem "redcarpet"

gem 'twitter'
gem 'tumblr4r'
gem 'ruby-oembed'

gem 'paperclip', '~> 3.5'
gem 'aws-s3'
gem 'aws-sdk'
gem "active_attr"
gem "active_enum"
gem "actionpack-action_caching"

# replacement for lack of autolink in rails 3.1+
gem 'rails_autolink'

# payment system
gem 'stripe'

gem 'httpclient'

group :development do
    gem 'js-routes'
    gem 'rails_refactor'
end

group :development, :test do
    gem 'rspec-rails', '~> 2.14'
    gem 'rspec-collection_matchers'
    gem 'pry'
    gem 'pry-rails'
    gem 'pry-doc'
    gem 'watchr'
    gem 'factory_girl_rails'
end

gem 'pg'

group :test do
    gem 'simplecov'
    gem 'capybara'
    gem 'poltergeist'
    gem 'selenium-webdriver'
    #gem 'guard-rspec'
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
