source 'https://rubygems.org'

ruby "2.2.3"

gem 'rails', '~> 4.2.0'
gem 'authlogic', '~> 3.4.0'

gem 'activeadmin', '~> 1.0.0.pre2'

gem 'rollbar', '~> 1.2.7'

# active admin requires devise which I am not using
# devise is not set up so we need to force it to not
# be required by default by rails so it is listed here
gem 'devise', :require => false

gem 'virtus', :git => 'git://github.com/solnic/virtus.git'
gem 'unicorn'

gem 'rails_12factor', group: :production

group :assets do
  gem 'sass-rails'
  gem 'foundation-rails'
  gem 'coffee-rails'
  gem 'sass'

  gem 'execjs'
  gem 'therubyracer', '~> 0.12.0'

  gem 'backbone-rails'
  gem 'foundation-icons-sass-rails'
  gem 'uglifier', '>= 1.0.3'
end

gem 'draper'
gem 'foundation_rails_helper'
gem 'best_in_place'

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
#gem "active_attr"
gem "active_enum"
gem "actionpack-action_caching"

# replacement for lack of autolink in rails 3.1+
gem 'rails_autolink'

gem 'httpclient'

group :development do
    gem 'js-routes'
    gem 'rails_refactor'
end

group :development, :test do
    gem 'test-unit'
    gem 'rspec-rails', '~> 2.14'
    gem 'rspec-collection_matchers'
    gem 'pry'
    gem 'pry-rails'
    gem 'pry-nav'
    gem 'pry-rescue'
    gem 'pry-pretty-numeric'
    gem 'pry-macro'
    gem 'pry-git'
    gem 'pry-doc'
    gem 'pry-docmore'
    gem 'pry-highlight'
    gem 'pry-stack_explorer'
    gem 'watchr'
    gem 'factory_girl_rails'
end

gem 'workflow'
gem 'pg'

group :test do
    gem 'simplecov'
    gem 'capybara'
    gem 'poltergeist'
    gem 'selenium-webdriver'
    gem 'launchy'
    gem 'faker'
    gem 'database_cleaner'
    gem 'sqlite3-ruby'
    gem 'shoulda-matchers'
end
