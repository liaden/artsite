require 'spec_helper'

describe WebhookInvocation do
  include ActiveJob::TestHelper

  it { should validate_presence_of(:third_party_name) }
  it { should validate_inclusion_of(:third_party_name).in_array(%w[StorEnvy Square]) }

  it { should validate_presence_of(:json_data) }

  describe "workflow" do
    describe "received state" do
      subject(:webhook) { FactoryGirl.create(:webhook) }

      it { is_expected.to be_received }

      describe '.start_processing!' do
        let(:wrap_processing) {}
        before do
          wrap_processing
          webhook.start_processing!
        end

        it { is_expected.to be_processing }
        it "enqueues job for processing"
      end
    end

    describe "processing state" do
      subject(:webhook) { FactoryGirl.create(:webhook, workflow_state: 'processing') }

      context '.succeeded!' do
        before { webhook.succeeded! }
        it { is_expected.to be_successful }
      end

      context '.failed!' do
        before { webhook.failed! }
        it  { is_expected.to be_failure }
      end
    end

    describe "sucessful state" do
    end

    describe "failure state" do
      subject(:webhook) { FactoryGirl.create(:webhook, workflow_state: 'failure') }

      describe '.retry' do
        let(:wrap_retry) { }
        before do
          wrap_retry
          webhook.retry!
        end

        it { is_expected.to be_processing }
      end
    end
  end # workflow

  let(:data) do
    { "x" => 5, "y" => { "z" => "a" } }
  end

  describe 'start processing' do
    let(:webhook) { FactoryGirl.create(:webhook, :data => data) }
    it 'sends data to processor' do
      webhook.start_processing
      expect(enqueued_jobs.size).to eq(1)
    end
  end

  describe 'data' do
    subject(:webhook_data) { FactoryGirl.create(:webhook, data: data).data }

    it { is_expected.to eq(data) }

    it "responds to symbols and keys" do
      expect(webhook_data[:x]).to_not be_nil
      expect(webhook_data['x']).to_not be_nil
    end

    it 'parses after fetching from database' do
      webhook_data
      expect(WebhookInvocation.last.data).to eq(data)
    end
  end
end
