class PageDecorator < ApplicationDecorator
  delegate_all

  def short_content
    h.truncate(object.content, :length => 120)
  end

  def created_at
    h.localize object.created_at
  end

  def updated_at
    h.localize object.updated_at
  end
end
