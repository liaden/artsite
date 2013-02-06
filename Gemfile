source 'https://rubygems.org'

gem 'rails', '3.2.2'

gem 'twitter-bootstrap-rails', :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
gem 'less-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  #gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'execjs'
  gem 'therubyracer', '~> 0.10.2'

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
    gem 'factory_girl_rails'
end

gem 'pg'

group :test do
    gem 'simplecov'
    gem 'capybara'
    gem 'guard-rspec'
    gem 'launchy'
    gem 'faker'
    gem 'database_cleaner'
end

# use thin server instead of WEBrick
if RUBY_PLATFORM =~ /(win|w)32$/
  gem "eventmachine", "~> 1.0.0.beta.4.1"
else
  gem "eventmachine"
end

gem "thin"

