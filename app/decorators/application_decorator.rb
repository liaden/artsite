class ApplicationDecorator < Draper::Decorator
  def facebook_like
    "<iframe src='//www.facebook.com/plugins/like.php?href=http%3A%2F%2Fwww.archaicsmiles.com#{ h.url_for model }&amp;send=false&amp;layout=standard&amp;width=450&amp;show_faces=true&amp;action=like&amp;colorscheme=light&amp;font&amp;height=80' scrolling='no' frameborder='0' style='border:none; overflow:hidden; width:450px; height:80px;' allowTransparency='true'></iframe>".html_safe
  end

  def error_message_title
    "There has been error."
  end

  def editable?
    h.admin?
  end

  def more_info_link
    h.link_to('more info', object)
  end

  def render_form_errors
    h.render :partial => 'partials/form_errors', :locals => { :item => self }
  end
end
