class AddAgeToBoardgame < ActiveRecord::Migration
  def change
    add_column :boardgames, :age, :integer
  end
end
