ActiveAdmin.register Tag do
  config.clear_action_items!

  controller do
    def scoped_collection
      Tag.includes(:artworks)
    end
  end

  index do 
    bip_column(:name)
    column(:artwork_count) do |tag|
      tag.artworks.size
    end
  end
end
