class Boardgame < ActiveRecord::Base
  has_attached_file 	:image,
                      :storage => :s3,
                      :default_url => ActionController::Base.helpers.asset_path("hero1.jpg"),
                      :bucket => 'getboardgames',
                      :s3_credentials => {
                        :access_key_id => 'AKIAI576XAU7SH57QZFA',
                        :secret_access_key => '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'
                      }

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
    mech = Mechanic.find_by_boardgame_id(id)
    if mech
      mech.mechanic_value
    end
  end

  def category
    cat = Category.find_by_boardgame_id(id)
    if cat
      cat.category_value
    end
  end

  #def price
  #  req = Vacuum.new
  #
  #  game = name
  #
  #  req.configure key:    'AKIAJWEKVGBSCPOG544A',
  #                secret: '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',
  #                tag:    'getboar-20'
  #
  #  params = { 'Operation'   => 'ItemSearch',
  #             'SearchIndex' => 'Toys',
  #             'Keywords'    => game,
  #             'ResponseGroup' => 'Offers,Small'}
  #
  #  @res = req.get query: params # XPath is your friend.
  #  doc = Nokogiri.XML(@res.body)
  #
  #  urlNode = doc.xpath('//xmlns:Item//xmlns:ItemLink//xmlns:URL')[0]
  #  priceNode = doc.xpath('//xmlns:Offer//xmlns:FormattedPrice')[0]
  #
  #  if (urlNode && priceNode)
  #    url = urlNode.text
  #    price  = priceNode.text
  #
  #    return [url,price]
  #  else
  #    return nil
  #  end
  #end

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
