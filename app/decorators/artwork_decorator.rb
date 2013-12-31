class ArtworkDecorator < ApplicationDecorator
  delegate_all
  decorates :artwork

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
