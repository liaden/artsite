class Webhooks::SquareController < ApplicationController
  def create
    hook = WebhookInvocation.create!(square_webhook_params)

    begin
      hook.start_processing!
    rescue
      # swallow errors since we have info to redo it later
      Rails.logger.error "Error with hook on start processing"
    end

    render head: :ok
  rescue
    render head: 500
  end

  private

  def square_webhook_params
    raise NotImplementedError
    { third_party_name: :Square }.merge(params).require()
  end
end
