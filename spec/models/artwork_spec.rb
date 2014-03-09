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

    it 'reqiuires fanart flag is set' do
      FactoryGirl.build(:artwork, :fanart => nil).should_not be_valid
    end

    it 'requries featured flag is set' do
      FactoryGirl.build(:artwork, :featured => nil).should_not be_valid
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

    it 'is original when not a fanart' do
      art = FactoryGirl.build(:artwork)
      art.should be_original
    end

    describe 'featured scope' do
      it 'lists the featured artwork' do
        FactoryGirl.create(:artwork, :featured => true)
        Artwork.featured.should have(1).item
      end
      it 'does not list unfeatured artwork' do
        FactoryGirl.create(:artwork, :featured => false)
        Artwork.featured.should be_empty
      end
    end

    describe 'fanart scope' do
      it 'lists the fanart' do
        FactoryGirl.create(:artwork, :fanart => true)
        Artwork.fanart.should have(1).item
      end

      it 'does not list original artworks' do
        FactoryGirl.create(:artwork, :fanart => false)
        Artwork.fanart.should be_empty
      end
    end

    describe 'original scope' do
      it 'does not list fanart' do
        FactoryGirl.create(:artwork, :fanart => true)
        Artwork.original.should be_empty
      end

      it 'lists the originals' do
        FactoryGirl.create(:artwork, :fanart => false)
        Artwork.original.should have(1).item
      end
    end

    describe 'for_year scope' do
      context 'it finds one when' do
        after(:each) { Artwork.for_year(2014).should have(1).item }
        it 'lists artwork created on january 1rst' do
          FactoryGirl.create(:artwork, :created_at => '01-01-2014')
        end
        it 'lists artwork created on december 31rst' do
          FactoryGirl.create(:artwork, :created_at => '12-31-2014')
        end
        it 'lists artwork created in july' do
          FactoryGirl.create(:artwork, :created_at => '07-04-2014')
        end
      end

      context 'does not find instances' do
        after(:each) { Artwork.for_year(2014).should be_empty }

        it 'if end of previous year' do
          FactoryGirl.create(:artwork, :created_at => '31-12-2013')
        end
        it 'does not list if beginning of following year' do
          FactoryGirl.create(:artwork, :created_at => '01-01-2015')
        end
      end
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

