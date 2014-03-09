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

  def edit_link_if_admin
    return '' unless h.admin? 
    h.link_to('Edit',  h.edit_artwork_path(self), :class => 'edit-link button')
  end

  def edit_prints_link
    unless self.new_record?
      h.link_to('Edit purchasing options', artwork_prints_path(self), :class => 'button')
    end
  end

  def delete_link_if_admin
    return '' unless h.admin?
    h.link_to('Delete', object, :confirm => "Are you sure you wish to delete #{object.title}?", :class => 'button alert', :method => :delete)
  end

  def created
    self.created_at.strftime('%m/%d/%Y')
  end

  def async_toggle_feature_link 
    text = object.featured? ? 'Remove from featured' : 'Feature'
    h.link_to(text, '#', :onclick => "toggle_feature(this)", :data => { 'update-url' => h.artwork_path(object, :format => :json) })
  end

  def async_delete_link
    h.link_to('Delete', '#', :onclick => "delete_artwork(this)", :data => { 'delete-url' => h.artwork_path(object, :format => :json)})
  end

  def admin_controls
    return '' unless h.admin?
    
    controls = [ method(:async_delete_link), method(:async_toggle_feature_link) ]
   
    content = h.link_to('#', :data => { :dropdown => "admin-#{object.id}"}) do
      h.content_tag(:i, :class => 'fi-widget right artwork-admin-controls' ) { }
    end
   
    menu = h.content_tag(:ul, :id => "admin-#{object.id}", :class => "f-dropdown") do
      controls_markup = controls.map do |control|
        h.content_tag(:li) do
          control.call
        end
      end

      controls_markup.join('').html_safe
    end
    content.concat(menu)
  end
end
