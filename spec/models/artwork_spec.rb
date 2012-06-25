require 'spec_helper'

describe Artwork do
    def valid_attributes
        { :title => 'Butterfly', :description => 'This is a description.',:image => File.open('db/seed_images/butterfly.jpg') }
    end


    it 'can be instantiated' do
        Artwork.new.should be_an_instance_of(Artwork)
    end


    it 'can create with valid parameters' do
        Artwork.create(valid_attributes).should be_persisted        
    end

    it 'fails without image_file_name' do
        invalid_attributes = valid_attributes.delete :image
        Artwork.create(invalid_attribtes).should_not be_persisted
    end

    
end

