class MatteColor < ActiveRecord::Base
    if Rails.env.production?
        has_attached_file :image, 
                          #:styles => { :carousel => "500x500", :thumbnail => "100x100" },
                          :storage => :s3,
                          :bucket => ENV['S3_BUCKET_NAME'],
                          :s3_credentials => {
                              :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
                              :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
                          }
    else
        has_attached_file :image, 
                          #:styles => { :carousel => "500x500", :thumbnail => "100x100" },
                          :path => ":rails_root/tmp/paperclip_test"
    end

    validates :color, :image_file_name, :inventory_count, :price_per_square_inch, :presence => true 
    validates :inventory_count, :numericality => { :greater_than_or_equal_to => 0 }
    validates :price_per_square_inch, :numericality => { :greater_than => 0 }
end

