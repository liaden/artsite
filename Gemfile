source 'https://rubygems.org'

gem 'rails', '3.2.2'

gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  #gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'execjs'
  gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

# caching
gem 'dalli'

gem 'authlogic'
gem 'friendly_id'

gem 'jquery-rails'

gem 'twitter'
gem 'tumblr4r'

gem 'paperclip'
gem 'aws-s3'
gem 'aws-sdk'

# replacement for lack of autolink in rails 3.1+
gem 'rails_autolink'

# payment system
gem 'stripe'

group :development, :test do
    gem 'rspec-rails'
    gem 'watchr'
end

gem 'pg'

group :development do
    #gem 'factory_girl'
end

group :test do
    gem 'factory_girl'
    gem 'factory_girl_rails'
    gem 'capybara'
    gem 'cucumber-rails'
    gem 'database_cleaner'
end

# use thin server instead of WEBrick
if RUBY_PLATFORM =~ /(win|w)32$/
  gem "eventmachine", "~> 1.0.0.beta.4.1"
else
  gem "eventmachine"
end
gem "thin"

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
