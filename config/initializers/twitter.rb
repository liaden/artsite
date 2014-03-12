if Rails.env.development? or Rails.env.test?
  require File.expand_path('../test_twitter', __FILE__)
end
