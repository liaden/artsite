module ApplicationHelper

    def control_group_tag
        "<div class='control-group'>#{yield}</div>".html_safe
    end

    def control_label_tag(params = {})
        if params[:label]
            "<label class='control-label'>#{params[:label]}</div>".html_safe
        else
            "<label class='control-label'>#{yield}</div>".html_safe
        end
    end

    def controls_tag
        "<div class='controls'>#{yield}</div>".html_safe
    end

    def form_actions_tag
        "<div class='form-actions'>#{yield}</div>".html_safe
    end

    def sizing_select_tag(params)
        text = "<select id='#{params[:id]}' name='#{params[:id]}' multiple='multiple'>"
        params[:list].each do |item|
            text += "<option>#{item[0]} (#{item[1]})</option>"
        end
        text += "</select>"
        text.html_safe
    end

    def remove_path(item)
        if item.class == Print
            "/cart/remove/artwork/#{item.id}"
        elsif item.class == Lesson
            "/cart/remove/class/#{item.id}"
        end
    end


    def admin?
        current_user and current_user.admin?
    end

    def admin_edit(item)
        if admin?
            # JOEL TODO: Need to fix so we actually link to edit of item
            link_to '(Edit)', (item), :class => 'edit-link'
        else
            ''
        end
    end

end
