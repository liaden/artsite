module Features
  module SupplyWorkflows
    def fill_in_supply_form(supply = nil)
      supply = FactoryGirl.build(:supply) unless supply

      fill_in :supply_name, :with => supply.name
      select supply.category, :from => :supply_category
      fill_in :supply_description, :with => supply.description
      fill_in :supply_short_description, :with => supply.short_description
      fill_in :supply_referral_url, :with => supply.referral_url
    end

    def submit_supply_form
      click_button('Create')
    end
  end
end
