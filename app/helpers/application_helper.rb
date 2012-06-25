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

    def purchase_form(params)
        # force prints into an array
        params[:prints] = [params[:prints]] unless params[:prints].is_a? Array

        form_tag(purchase_path, :method => :post, :class => "form-horizontal") do
            text = '<input id="transaction_type" type="hidden" value="artwork" name="transaction_type">'
            text += '<input id="material" type="hidden" value="'+"#{params[:material]}"+'" name="material">'
            text += '<input id="item_id" type="hidden" value="'+"#{params[:id]}" + '" name="item_id">'
            text += "<table id='art-price-table' class='table  table-condensed'><theader><tr><th class='print-header'>&nbsp;</th><th class='print-header'>Size</th><th class='print-header'>Price</th></tr></theader><tbody>"
            
            # force nil to false as well
            disabled = params[:disabled] ? true : false
            
            params[:prints].each do |print|
                text += "<tr><td>#{check_box_tag :Size, print.dimensions, :disabled => disabled}</td><td>#{print.dimensions}</td><td>#{print.price}</td></tr>"
            end
            text += "</tbody></table>"
            text += "<div class='well'>"
            text +=    submit_tag "Add to Cart", :class => "btn btn-primary"
            text += "</div>"
            text.html_safe
        end
    end

end
