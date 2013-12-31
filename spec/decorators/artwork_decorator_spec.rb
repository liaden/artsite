require 'spec_helper'

describe ArtworkDecorator do
    let(:artwork) { FactoryGirl.create :artwork }
    let(:decorated) { ArtworkDecorator.decorate artwork }

    before(:each) { mock_paperclip_post_process }

    it 'can be liked on facebook' do
        decorated.facebook_like.should match /.iframe.*facebook.*artworks\/.*/
    end


end
