class PageDecorator < ApplicationDecorator
  delegate_all

  def short_content(max_length=nil)
    h.truncate(object.content, :length => max_length || 120)
  end

  def created_at
    h.localize object.created_at
  end

  def updated_at
    h.localize object.updated_at
  end
end
