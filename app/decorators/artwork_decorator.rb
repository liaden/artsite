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
end
