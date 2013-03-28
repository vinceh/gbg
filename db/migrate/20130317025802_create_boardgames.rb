class CreateBoardgames < ActiveRecord::Migration
  def up
    create_table :boardgames do |t|
      t.string    "name"
      t.string    "bgg_rating"
      t.string    "user_rating"
      t.string    "num_votes"
      t.string    "bgg_id"
      t.string    "year_published"
      t.integer   "min_num_players"
      t.integer   "max_num_players"
      t.integer   "playing_time"
      t.string    "image_url"

      # for paperclip
      t.string    "image_file_name"
      t.string    "image_file_size"
      t.string    "image_content_type"
      t.string    "image_updated_at"
    end

    create_table :subdomains do |t|
      t.integer   "boardgame_id"
      t.string   "subdomain_value"
    end

    create_table :categories do |t|
      t.integer   "boardgame_id"
      t.string    "category_value"
    end

    create_table :mechanics do |t|
      t.integer   "boardgame_id"
      t.string   "mechanic_value"
    end

    create_table :honours do |t|
      t.integer   "boardgame_id"
      t.string   "honour_value"
    end
  end

  def down
    drop_table :boardgames
    drop_table :subdomains
    drop_table :categories
    drop_table :mechanics
    drop_table :honours
  end
end
