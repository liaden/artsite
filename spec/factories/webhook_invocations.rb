FactoryGirl.define do
  factory :webhook, class: :webhook_invocation do
    third_party_name 'Square'
    data Hash.new

    factory :square_webhook do
      third_party_name 'Square'
    end

    factory :storenvy_webhook do
      third_party_name 'StorEnvy'
    end
  end
end
