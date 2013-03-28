class AddDescToBoardgame < ActiveRecord::Migration
  def change
    add_column :boardgames, :desc, :text
  end
end
