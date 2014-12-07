ActiveAdmin.register Print do
  decorate_with PrintDecorator
  config.clear_action_items!

  controller do
    def scoped_collection
      Print.includes(:artwork)
    end
  end
  
  index do
    column(:artwork) do |print|
      image_tag(print.artwork_thumbnail_url, :class => 'mini-thumbnail')
    end

    column(:price) { |print| best_in_place print, :price, :path => artwork_print_path(print.artwork, print) }
    column(:is_sold_out) { |print| best_in_place print, :is_sold_out, :collection => ['no', 'yes'], :path => artwork_print_path(print.artwork, print) }
    column(:is_on_show) { |print| best_in_place print, :is_on_show, :collection => ['no', 'yes'], :path => artwork_print_path(print.artwork, print) }
    column(:material) 
    column(:inventory_count) { |print| best_in_place print, :inventory_count, :path => artwork_print_path(print.artwork, print) }
    column(:sold_count) { |print| best_in_place print, :sold_count, :path => artwork_print_path(print.artwork, print) }

    column do |print|
      link_to 'edit', edit_artwork_print_path(print.artwork, print)
    end
  end

end
