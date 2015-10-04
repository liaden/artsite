class CreateWebhookInvocations < ActiveRecord::Migration
  def change
    create_table :webhook_invocations do |t|
      t.string :third_party_name
      t.string :workflow_state
      t.text :json_data

      t.timestamps
    end
  end
end
