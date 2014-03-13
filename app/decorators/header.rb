class Header < PartialDecorator
  def to_s
    h.render :partial => 'partials/header', :locals => { :header => self }
  end
end
