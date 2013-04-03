class Boardgame < ActiveRecord::Base
  attr_accessible :thumbnail
  has_attached_file :thumbnail

  has_many :categories
  has_many :honours
  has_many :mechanics
  has_many :subdomains

  def num_players
    if min_num_players == max_num_players
      return min_num_players
    else
      return min_num_players.to_s+"-"+max_num_players.to_s
    end
  end

  def self.top_boardgames(num = 10)
    return Boardgame.limit(num).order('gbg_rating desc')
  end
end
