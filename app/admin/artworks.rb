ActiveAdmin.register Artwork do
  decorate_with ArtworkDecorator
  config.clear_action_items!

  index do
    column(:image) do |artwork|
      image_tag(artwork.image.url(:thumbnail), :class => 'mini-thumbnail')
    end

    bip_column(:title) 
    bip_column(:featured, :bip => { :type => :checkbox, :collection => ['no', 'yes'] }) 
    bip_column(:fanart, :bip => { :type => :checkbox, :collection => ['no', 'yes']} )

    column(:created, :sortable => :created_at) 

    actions :defaults => false do |artwork|
      link_to 'edit', edit_artwork_path(artwork)
    end
  end

  action_item do
    link_to "New Artwork", new_artwork_path
  end
end
