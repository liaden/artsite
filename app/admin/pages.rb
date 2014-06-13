ActiveAdmin.register Page do
  config.clear_action_items!

  index do
    bip_column(:name)
    bip_column(:page_type, :bip => { :type => :checkbox, :collection => [ "Video", "Tutorial" ] })
    column(:content)

    actions :defaults => false do |page|
      link_to 'edit', edit_page_path(page)
    end
  end
end
