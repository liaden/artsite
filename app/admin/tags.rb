ActiveAdmin.register Tag do
  index do 
    bip_column(:name)
    column(:artwork_count) do |tag|
      tag.artworks.size
    end
  end
end
