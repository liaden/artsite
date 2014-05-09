ActiveAdmin.register Supply do
  config.clear_action_items!

  index do
    bip_column(:name) 
    column(:category) 
    column(:referral_url) { |supply| link_to supply.referral_url, supply.referral_url, :target => '_blank' }
    column(:description) 
    column('Created', :created_at)
    actions :defaults => false do |supply|
      link_to 'edit', edit_supply_path(supply)
    end
  end

  action_item do
    link_to 'New art supply'
  end
end
