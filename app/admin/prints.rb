ActiveAdmin.register Print do
  decorate_with PrintDecorator

  index do
    column(:artwork) do |print|
      image_tag(print.artwork_thumbnail_url, :class => 'mini-thumbnail')
    end
    column(:price)
    column(:is_sold_out)
    column(:is_on_show)
    column(:material)
    column(:inventory_count)
    column(:sold_count)
  end
end
