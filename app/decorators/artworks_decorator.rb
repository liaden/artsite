class ArtworksDecorator < Draper::CollectionDecorator

  def categories
    %w( Featured ) + Time.now.year.downto(2010).to_a + %w( Fanart All ) 
  end

  def filter_link(category)
    category = category.to_s
    classes = "button category-button black #{'active' if context[:category] == category}"
    h.link_to(category, h.artworks_by_category_path(category), :class => classes, :id => "#{category.downcase}-filter" )
  end

  def category_title
    context[:category].capitalize
  end

end
