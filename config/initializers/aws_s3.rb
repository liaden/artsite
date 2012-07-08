if Rails.env.development? or Rails.env.test?  
    require File.expand_path('../test_aws_s3', __FILE__)
end

