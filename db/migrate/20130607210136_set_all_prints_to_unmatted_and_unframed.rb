class SetAllPrintsToUnmattedAndUnframed < ActiveRecord::Migration
  def up
    Print.all.each do |p|
        p.matte = Matte.unmatted
        p.frame = Frame.unframed
        p.save!
    end
  end

  def down
    Print.all.each do |p|
        p.matte = nil
        p.frame = nil
    end
  end
end
