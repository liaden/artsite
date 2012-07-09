if Rails.env.development? or Rails.env.test?  
    require File.expand_path('../test_mail', __FILE__)
end

ActionMailer::Base.smtp_settings = {
    :address => 'smtp.sendgrid.com',
    :port => '587',
    :authentication => :plain
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :domain => ENV['SENDGRID_DOMAIN']
}
