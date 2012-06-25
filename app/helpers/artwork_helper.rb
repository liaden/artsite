module ArtworkHelper
    def price_sizes(size_name, size, price, canvas_price)
        line = "<tr><td>#{label_tag(size_name)}</td>"
        line += "<td>#{text_field_tag("#{size_name}_size", size) }</td>"
        line += "<td>#{text_field_tag("#{size_name}_price", price)}</td>" 
        if size_name != "original"
            line += "<td>#{text_field_tag("#{size_name}_canvas_price", canvas_price)}</td></tr>"
        end
        line.html_safe
    end
end
