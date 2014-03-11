class Banner
  def initialize(picture)
    @picture = picture
  end

  def sizes
    @sizes ||= {1 => 360, 360 => 720, 720 => 1024,
                1024 => 1280, 1280 => 1440, 1440 => 1680,
                1680 => 1920, 1920 => 2560}
  end

  def url(image_width)
    "http://s3.amazonaws.com/ArchaicSmiles/banner/#{@picture}/#{image_width}.jpg"
  end

  def rule(min_width, image_width)
    "[#{url(image_width)}, (only screen and (min-width: #{min_width}px))]"
  end

  def data_interchange
    "data-interchange=\"#{sizes.map() { |key,value| rule(key, value) }.join(', ')}\""
  end

  def tag(id=nil)
    "<img id=\"#{id}\" #{data_interchange}></div>".html_safe
  end
end
