ActiveAdmin.register Show do
  decorate_with ShowDecorator

  index do
    bip_column(:name)
    bip_column(:date)
    bip_column(:address)
    bip_column(:show_type, :bip => {:type => :checkbox, :collection => ["Convention", "Gallery"] })
    
    actions :defaults => false do |show|
      link_to 'edit', edit_show_path(show)
    end
  end
end
