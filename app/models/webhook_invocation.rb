class WebhookInvocation < ActiveRecord::Base
  THIRD_PARTIES = %w[ StorEnvy Square ]

  include Workflow

  # conditionally validate stuff on 'received'?
  validates :third_party_name,
    presence: true,
    inclusion: { in: THIRD_PARTIES }

  validates :json_data,
    presence: true

  workflow do
    state :received do
      event :start_processing, transition_to: :processing
      event :failed, transition_to: :failure
    end

    state :processing do
      event :succeeded, transition_to: :successful
      event :failed, transition_to: :failure
    end

    state :successful

    state :failure do
      event :retry, transition_to: :processing
      event :failed, transition_to: :failure
    end
  end

  def start_processing
    processor.perform_later(data)
  end

  def data
    @data ||= JSON.parse(json_data).with_indifferent_access
  end

  def data=(value)
    if value.is_a? String
      @data = JSON.parse(value).with_indifferent_access
    else
      @data = value.with_indifferent_access
      value = value.to_json
    end

    self.json_data = value
  end

  private

  def processor
    "#{third_party_name}Job".constantize
  end
end
