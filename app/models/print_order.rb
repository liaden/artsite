class PrintOrder < ActiveRecord::Base
    belongs_to :print
    belongs_to :order, :autosave => true
    belongs_to :frame, :autosave => true
    belongs_to :matte, :autosave => true
    
    validates :print_id, :order_id, :frame_id, :matte_id, :presence => true

    before_validation  :default_values
    before_save :delete_potential_orphaned_matte

    def delete_potential_orphaned_matte
        database_version = PrintOrder.find_by_id(self.id)

        if database_version != nil
            if self.matte_id != database_version.matte_id
                database_version.matte.destroy
            end
        end
    end

    def default_values
        self.frame ||= Frame.unframed
        self.matte ||= Matte.unmatted
    end

    def framed?
        frame.framed?
    end

    def matted?
        matte.matted?
    end

    def price
        return print.price if print.original?

        # todo: give frame something that can give the right size if it is matted
        print.price + frame.price(print) # + matte.price(print)
    end

    def cost
    end

    def height_width
        print_dims = print.height_width
        matte_dims = matte.height_width print_dims
        frame_dims = frame.height_width matte_dims
        frame.height_width(matte.height_width(print.height_width))
    end

    validates_each :frame_id do |record, attr, value|
        if record.frame and record.print
            dimensions = record.height_width
            if dimensions[:height] > 60 or dimensions[:width] > 60
                record.errors.add "The specified frame is too large."
            end
        end
    end

    validates_each :matte_id do |record, attr, value|
        if record.matte and record.print
            dimensions = record.matte.height_width record.print.height_width
            if dimensions[:height] > 40 or dimensions[:width] > 40
                record.errors.add "The specified matte cannot exceed 30x40"
            end
        end
    end
end
