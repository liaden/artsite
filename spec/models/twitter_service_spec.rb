require 'spec_helper'

describe TwitterService do
  let(:service) { TwitterService.new }

  before(:each) do
    service.client.should_receive(:oembeds) do
      [ Twitter::OEmbed.new(:html => "<div id=\"foo\">x</div>", :url => "https://twitter.com/archaicsmiles/statuses/443507928205889536") ]
    end
    service.client.should_receive(:user_timeline) do
      []
    end
  end

  it 'syncs tweets from last' do
    FactoryGirl.create(:tweet)

    expect { service.sync  }.to change{Tweet.count}.by(1)
  end

  it 'syncs all tweets' do
    expect { service.sync }.to change{Tweet.count}.by(1)
  end
end
