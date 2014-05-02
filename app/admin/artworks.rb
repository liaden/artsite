ActiveAdmin.register Artwork do
  decorate_with ArtworkDecorator

  index do
    column(:image) do |artwork|
      image_tag(artwork.image.url(:thumbnail), :class => 'mini-thumbnail')
    end
    column(:title)
    column(:featured)
    column(:fanart)
    column(:created) 
  end
end
