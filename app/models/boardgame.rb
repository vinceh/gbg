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

  def mechanic
    Mechanic.find_by_boardgame_id(id).mechanic_value
  end

  def category
    Category.find_by_boardgame_id(id).category_value
  end

  def self.top_boardgames(num = 10)
    return Boardgame.limit(num).order('gbg_rating desc')
  end

  def self.categories
    ["Adventure",
     "Ancient/Mythology",
     "Card/Classic",
     "Economic/Political",
     "Family",
     "Fantasy/Sci-Fi",
     "Medieval/Cultural",
     "Miniatures/Expansions",
     "Modern Themes",
     "War"]
  end

  def self.category_map
    {"Action /Dexterity" => "Adventure",
     "Adventure" => "Adventure",
     "American Civil War" => "War",
     "Vietnam War" => "War",
     "American Indian Wars" => "War",
     "Wargame" => "War",
     "World War I" => "War",
     "World War II" => "War",
     "American Revolutionary War" => "War",
     "American West" => "Medieval/Cultural",
     "Ancient" => "Ancient/Mythology",
     "Animals" => "Modern Themes",
     "Aviation / Flight" => "Adventure",
     "Bluffing" => "Card/Classic",
     "Word Game" => "Card/Classic",
     "Book" => "Family",
     "Card Game" => "Card/Classic",
     "Children's Game" => "Family",
     "City Building" => "Economic/Political",
     "Civil War" => "War",
     "Civilization" => "Economic/Political",
     "Collectible Components" => "Miniatures/Expansions",
     "Comic Book / Strip" => "Card/Classic",
     "Deduction" => "Card/Classic",
     "Dice" => "Card/Classic",
     "Economic" => "Economic/Political",
     "Educational" => "Family",
     "Electronic" => "Fantasy/Sci-Fi",
     "Zombies" => "Fantasy/Sci-Fi",
     "Environmental" => "Economic/Political",
     "Exploration" => "Adventure",
     "Fantasy" => "Fantasy/Sci-Fi",
     "Abstract Strategy" => "Fantasy/Sci-Fi",
     "Farming" => "Economic/Political",
     "Fighting" => "Modern Themes",
     "Game System" => "Card/Classic",
     "Horror" => "Fantasy/Sci-Fi",
     "Humor" => "Card/Classic",
     "Industry / Manufacturing" => "Economic/Political",
     "Korean War" => "War",
     "Mafia" => "Modern Themes",
     "Mature / Adult" => "Modern Themes",
     "Maze" => "Card/Classic",
     "Medical" => "Modern Themes",
     "Medieval" => "Medieval/Cultural",
     "Memory" => "Card/Classic",
     "Miniatures" => "Miniatures/Expansions",
     "Modern Warfare" => "War",
     "Movies / TV / Radio theme" => "Fantasy/Sci-Fi",
     "Murder/Mystery" => "Modern Themes",
     "Mythology" => "Ancient/Mythology",
     "Napoleonic" => "War",
     "Nautical" => "Adventure",
     "Negotiation" => "Economic/Political",
     "Novel-based" => "Fantasy/Sci-Fi",
     "Party Game" => "Card/Classic",
     "Pirates" => "Adventure",
     "Political" => "Economic/Political",
     "Prehistoric" => "Ancient/Mythology",
     "Print & Play" => "Card/Classic",
     "Puzzle" => "Card/Classic",
     "Racing" => "Modern Themes",
     "Real-time" => "Card/Classic",
     "Religious" => "Medieval/Cultural",
     "Renaissance" => "Medieval/Cultural",
     "Science Fiction" => "Fantasy/Sci-Fi",
     "Space Exploration" => "Fantasy/Sci-Fi",
     "Spies/Secret Agents" => "Fantasy/Sci-Fi",
     "Video Game Theme" => "Fantasy/Sci-Fi",
     "Sports" => "Modern Themes",
     "Territory Building" => "Economic/Political",
     "Trains" => "Modern Themes",
     "Transportation" => "Modern Themes",
     "Travel" => "Modern Themes"
    }
  end
end
