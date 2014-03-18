class ArtworkCategory
  attr_reader :name

  def initialize(name)
    @predefined_categories = %w(All Featured Fanart)
    @name = name || 'Featured'
  end

  def year?
    @name.match(/^\d\d\d\d$/) != nil
  end

  def predefined?
    @predefined_categories.any? { |cat| cat == @name }
  end

end
