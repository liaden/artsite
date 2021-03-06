# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/lib/'
  add_filter '/vendor/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Decorators', 'app/decorators'
  add_group 'Helpers', 'app/helpers'
  add_group 'Views', 'app/views'
  add_group 'Mailers', 'app/mailers'
end

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/collection_matchers'

silence_stream STDOUT do
  load 'db/schema.rb'
end

require 'rspec/autorun'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'database_cleaner'
require 'authlogic/test_case'
require 'best_in_place/test_helpers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  DatabaseCleaner.strategy = :truncation

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    # speed up tests by not generating thumbnails for rack_test
    if Capybara.current_driver == :rack_test
      mock_paperclip_post_process  
    end
  end

  config.include Features::ArtShowWorkflows, :type => :feature
  config.include Features::SupplyWorkflows, :type => :feature

end

# monkey patch active record for capybara with selenium
class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

include Authlogic::TestCase

RSpec::Matchers.define :have_leading_spaces do 
    match do |target|
        target.start_with? " "
    end
end

RSpec::Matchers.define :have_trailing_spaces do 
    match do |target|
        target.end_with? " "
    end
end

RSpec::Matchers.define :have_created do |params|
    match do |model|
        model.count - params[:starting_count] == params[:amount] 
    end

    failure_message_for_should do |model|
        "Created #{model.count - params[:starting_count]} of #{model.name} when #{params[:amount]} was expected"
    end

end

RSpec::Matchers.define :have_facebook_metatags do |params|
    match do |page|
        page.has_selector?("meta[property='og:title']",       :visible => false) and
        page.has_selector?("meta[property='og:type']",        :visible => false) and
        page.has_selector?("meta[property='og:url']",         :visible => false) and
        page.has_selector?("meta[property='og:site_name']",   :visible => false) and
        page.has_selector?("meta[property='og:description']", :visible => false) 
    end
end

def check_footer_header page
    page.should have_selector("div.navbar-fixed-top")
    page.should have_selector("div.navbar-fixed-bottom")
    page.should have_selector("div.copyright")
    page.should have_selector("div.footer-contact")
end
