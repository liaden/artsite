class HorizontalLabel < Draper::Decorator
  def initialize(form)
    @form = form
  end

  def tag(attribute)
    label_tag = h.content_tag(:div, :class => "small-4 columns") do
      @form.label(attribute, :class => 'inline')
    end
    field_tag = h.content_tag(:div, :class => "small-8 ") do 
      yield
    end

    label_tag.concat(field_tag)
  end
end
