class AddGbgRatingToBoardgames < ActiveRecord::Migration
  def change
    add_column :boardgames, :gbg_rating, :decimal, :precision => 8, :scale => 2
  end
end
