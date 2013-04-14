class AddPriceAndUrl < ActiveRecord::Migration
  def change
    add_column :boardgames, :price, :string
    add_column :boardgames, :amazon_url, :string
  end
end
