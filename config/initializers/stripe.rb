
if Rails.env.development? or Rails.env.test?  
    require File.expand_path('../test_stripe', __FILE__)
end

logger.debug "Initializing stripe..."
Stripe.api_key = ENV["STRIPE_PRIVATE_KEY"]
STRIPE_PUBLIC_KEY = ENV["STRIPE_PUBLIC_KEY"]
