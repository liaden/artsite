class HorizontalLabel < Draper::Decorator
  def initialize(form)
    @form = form
  end

  def tag(attribute, options = { } )
    options = {:label_size => 4, :field_size => 8}.merge(options)

    label_tag = h.content_tag(:div, :class => "small-#{options[:label_size]} columns") do
      @form.label(attribute, :class => 'inline')
    end
    field_tag = h.content_tag(:div, :class => "small-#{options[:field_size]} columns") do 
      yield
    end

    label_tag.concat(field_tag)
  end

end
