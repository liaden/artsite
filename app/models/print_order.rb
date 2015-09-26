class PrintOrder < ActiveRecord::Base
  belongs_to :print
  belongs_to :order, autosave: true

  validates :print_id, :order_id, :presence => true

  delegate :price, :to => :print, :prefix => false

  def cost
  end

  delegate :height_width, :to => :print, :prefix => false
end
