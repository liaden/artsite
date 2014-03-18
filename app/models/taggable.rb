module Taggable

    def taggable table, options = {}
        plural_lower = options[:plural] || "#{table.name.pluralize.downcase}"
        singular_lower = "#{table.name.downcase}"

        #def tags_csv
        self.send(:define_method, "#{plural_lower}_csv") do
            names = self.send(plural_lower).map { |item| item.name }
            names.join ","
        end

        # has_many artwork_tags
        # has_many tags, :through => artwork_tags, :uniq => true, :autosave => true
        join_table = "artwork_#{plural_lower}".to_sym
        has_many join_table
        has_many plural_lower.to_sym, :through => join_table, :uniq => true, :autosave => true

        # def create_tags_from_csv
        self.send(:define_method, "create_#{plural_lower}_from_csv") do |csv_values|
            return unless csv_values

            old_items = self.send(plural_lower).to_a

            new_items = csv_values.split(",").map { |item| table.find_or_create_by_name(item) } 
            self.send "#{plural_lower}=", new_items

            old_items.each do |item| 
                item.destroy if item.artworks.empty?  
            end
        end
    end
end
