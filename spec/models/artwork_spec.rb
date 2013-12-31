require 'spec_helper'

describe Artwork do

    before(:each) do
        @containing_folder = './spec/images/'
        @watercolor = "#{@containing_folder}watercolor.png"
        @create = "#{@containing_folder}create.jpg"
        @rails = "#{@containing_folder}rails.png"
    end

    before(:each) { mock_paperclip_post_process }

    it 'can create with valid parameters' do
        FactoryGirl.create(:artwork, :image => File.new(@watercolor)).should be_valid
    end

    it 'has a slug' do
        @artwork = FactoryGirl.create(:artwork)
        @artwork.slug.should_not be_nil
        @artwork.slug.size.should_not eql(0)
    end
    
    it 'requires the title' do
        FactoryGirl.build(:artwork, :title => nil).should_not be_valid
    end

    it 'requires a description' do
        FactoryGirl.build(:artwork, :description => nil).should_not be_valid
    end

    it 'creates tags and medium from csv' do
        art = Artwork.create(FactoryGirl.attributes_for :artwork) do |art|
            art.create_tags_from_csv "a,b,c,d"
            art.create_medium_from_csv "1,2,3,4"
        end

        art.tags.should have(4).items
        art.medium.should have(4).items
    end

    it 'does not leave orphaned tags and medium' do
        art = FactoryGirl.create(:tagged_artwork_in_medium)

        art.create_tags_from_csv 'x,y,z'
        art.create_medium_from_csv 'junk'

        Tag.count.should == 3
        Medium.count.should == 1
    end

    context 'with prints' do
        let(:artwork) { FactoryGirl.create(:artwork) }
        let(:sizes) {["1x1", "2x2", "3x3", "4x4", "5x5"]} 
        before(:each) do
            prints1 =  [0,1,2,3,4].map do |index|
                FactoryGirl.create(:print, :dimensions => sizes[index], :material => 'photopaper', :artwork => artwork)
            end

            prints2 = [1, 2, 3, 4,].map do |index|
                FactoryGirl.create(:print, :dimensions => sizes[index], :material => 'canvas', :artwork => artwork)
            end

            @prints = prints1 + prints2
        end

        it 'finds the print by dimensions and material' do
            print = @prints.last
            
            item = artwork.find_print :dimensions => print.dimensions, :material => print.material

            item.id.should eql(print.id)
        end

        it 'returns the sizes' do
            artwork.sizes.should eql(sizes)
        end
    end

    it 'fails without image_file_name' do
        FactoryGirl.build(:artwork, :image => nil).should_not be_valid
    end
    
end

