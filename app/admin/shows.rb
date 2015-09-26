ActiveAdmin.register Show do
  decorate_with ShowDecorator
  config.clear_action_items!

  index do
    bip_column(:name)
    bip_column(:date)
    bip_column(:address)
    bip_column(:show_type, :bip => {:as => :checkbox, :collection => ["Convention", "Gallery"] })

    actions :defaults => false do |show|
      link_to 'edit', edit_show_path(show)
    end
  end

  action_item do
    link_to 'New Show', new_show_path
  end
end
