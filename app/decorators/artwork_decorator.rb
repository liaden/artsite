class ArtworkDecorator < ApplicationDecorator
  delegate_all

  def header
    Header.new \
      :title => Proc.new { best_in_place_if artwork.editable?, artwork, :title  },
      :subheader => Proc.new { best_in_place_if artwork.editable?, artwork, :created, :as => :date  }
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
      h.link_to('Edit purchasing options', h.artwork_prints_path(self), :class => 'button')
    end
  end

  def delete_link_if_admin
    return '' unless h.admin?
    h.link_to('Delete', object, :confirm => "Are you sure you wish to delete #{object.title}?", :class => 'button alert', :method => :delete)
  end

  def created
    h.localize object.created_at
  end

  def featured
    object.featured ? 'yes' : 'no'
  end

  def fanart
    object.fanart ? 'yes' : 'no'
  end

  def async_toggle_feature_link 
    add_text = 'Feature'
    remove_text = 'Remove from featured'
    text = object.featured? ? remove_text : add_text
    h.link_to(text, '#', :onclick => "toggle_field(this, 'featured')", 
        :data => { 'update-url' => h.artwork_path(object, :format => :json),
                   'is-featured' => object.featured?,
                   'add-featured' => add_text,
                   'remove-featured' => remove_text
                 })
  end

  def async_delete_link
    h.link_to('Delete', '#', :onclick => "delete_artwork(this)", :data => { 'delete-url' => h.artwork_path(object, :format => :json)})
  end

  def async_flag_fanart_link
    add_text = 'Flag fanart'
    remove_text = 'Unflag fanart'
    
    text = object.original? ? add_text : remove_text 

    h.link_to(text, '#', :onclick => 'toggle_field(this, "fanart")', 
        :data => { 'update-url' => h.artwork_path(object, :format => :json),
                   'is-fanart' => object.fanart?,
                   'remove-fanart' => remove_text,
                   'add-fanart' => add_text })
  end

  def admin_controls
    return '' unless h.admin?
    
    controls = [ method(:async_delete_link), method(:async_toggle_feature_link), method(:async_flag_fanart_link) ]
   
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
