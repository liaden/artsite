module InventoryHelper
    def print_count(artwork, material, size_name)
        print = artwork.prints.where(:material => material, :size_name => size_name).first

        return "N/A" unless print

        return print.inventory_count.to_s
    end
end
