class ShowDecorator < ApplicationDecorator
  delegate_all

  def date
    object.date.strftime('%m/%d/%Y') 
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
