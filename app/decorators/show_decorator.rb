class ShowDecorator < ApplicationDecorator
  delegate_all

  def header
    Header.new(
      :title => lambda do 
        raw best_in_place_if(art_show.editable?, art_show, :name) +
        h.content_tag(:small) { art_show.edit_link_if_admin }
      end,
      :subheader => lambda { best_in_place_if art_show.editable?, art_show, :date, :type => :date }
    )
  end

  def date
    return '' unless object.date
    h.localize object.date
  end

  def short_description
    h.truncate(object.description, 45)
  end

  def edit_link_if_admin
    return '' unless h.admin?
    h.link_to('Edit', h.edit_show_path(object), :class => 'edit-link button')
  end

  def google_maps_address_link
    h.link_to(object.address, "http://maps.google.com/maps?q=#{object.address.gsub(/ /, '+').gsub(/;/, '')}")
  end
end
