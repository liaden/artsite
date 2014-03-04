class ArtworkDecorator < ApplicationDecorator
  delegate_all

  def canvas
    CanvasOptions.decorate_collection prints.canvas
  end

  def photopaper
    PhotopaperOptions.decorate_collection prints.photopaper  
  end

  def original
    OriginalOptions.decorate_collection prints.original
  end

  def form_title
    h.content_tag(:div, :class => 'row') do
      h.content_tag(:h1) do
        self.new_record? ? 'Upload New Art' : "Edit #{self.title}"
      end
    end
  end

  def edit_prints_link
    unless self.new_record?
      h.link_to('Edit purchasing options', artwork_prints_path(self), :class => 'button')
    end
  end
end
