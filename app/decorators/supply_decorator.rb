class SupplyDecorator < ApplicationDecorator
  delegate_all

  def select_category(form)
    valid_categories = Supply.supply_categories
    form.select(:category, valid_categories.zip(valid_categories), :label => false)
  end

  def admin_delete_link
    return '' unless h.admin?
    h.link_to('delete', h.supply_path(object), :method => :delete)
  end

  def admin_edit_link
    return '' unless h.admin?
    h.link_to('edit', h.edit_supply_path(object))
  end

  def header
    title = object.name + ' ' + admin_edit_link
    Header.new :title => title.html_safe, :subheader => object.category
  end
end
