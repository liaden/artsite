class PrintDecorator < ApplicationDecorator
  delegate_all

  def artwork_thumbnail_url
    object.artwork.image.url(:thumbnail)
  end
end
