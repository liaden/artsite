class RenameArticlesTableToPages < ActiveRecord::Migration
  def up
    drop_table :articles

    create_table :pages do |t|
      t.string :name
      t.string :page_type
      t.text :content
    end
  end

  def down
    drop_table :pages
    create_table :articles
  end
end
