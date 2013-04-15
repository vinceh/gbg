desc "This task is called by the Heroku scheduler add-on"
task :scrape => :environment do

  require 'nokogiri'
  require 'open-uri'

  domain = "http://boardgamegeek.com"

  2.upto(10) do |i|
    url = "http://boardgamegeek.com/browse/boardgame/page/" + i.to_s + "?sort=rank&sortdir=asc"
    doc = Nokogiri::HTML(open(url))

    node = doc.css("#row_").each do |item|

      bg = Boardgame.new

      bg.name = item.css(".collection_objectname a").text.squish
      puts "Getting data for " + bg.name + "..."

      bg.bgg_rating = item.css(".collection_bggrating").first.text.squish
      bg.user_rating = item.css(".collection_bggrating")[1].text.squish
      bg.num_votes = item.css(".collection_bggrating")[2].text.squish

      gameurl = domain + item.css(".collection_objectname a").first['href']
      gameid = /\d+/.match(gameurl)
      bg.bgg_id = gameid[0]

      sleep(0.5)
      gamedoc = Nokogiri::XML(open("http://www.boardgamegeek.com/xmlapi/boardgame/" + gameid[0]))

      bg.image_url = gamedoc.css("image").text.squish
      bg.year_published = gamedoc.css("yearpublished").text.squish
      bg.min_num_players = gamedoc.css("minplayers").text.squish.to_i
      bg.max_num_players = gamedoc.css("maxplayers").text.squish.to_i
      bg.playing_time = gamedoc.css("playingtime").text.squish.to_i
      bg.desc = gamedoc.css("description").text.squish
      bg.save!

      gamedoc.css("boardgamesubdomain").each do |s|
        bg.subdomains.create(:subdomain_value => s.text.squish)
      end
      gamedoc.css("boardgamecategory").each do |s|
        bg.categories.create(:category_value => s.text.squish)
      end
      gamedoc.css("boardgamemechanic").each do |s|
        bg.mechanics.create(:mechanic_value => s.text.squish)
      end
      gamedoc.css("boardgamehonor").each do |s|
        bg.honours.create(:honour_value => s.text.squish)
      end
    end
  end
end

task :top => :environment do

  totalCat = 0
  puts Category.group('category_value').order('count_category_value DESC').limit(15).count('category_value')
  Category.group('category_value').order('count_category_value DESC').limit(15).count('category_value').each do |key, value|
    totalCat = totalCat + value
  end
  puts totalCat
  puts Category.all.length
  puts (totalCat.to_f/Category.all.length.to_f).to_s
  puts ""

  totalMech = 0
  puts Mechanic.group('mechanic_value').order('count_mechanic_value DESC').limit(10).count('mechanic_value')
  Mechanic.group('mechanic_value').order('count_mechanic_value DESC').limit(10).count('mechanic_value').each do |key, value|
    totalMech = totalMech + value
  end
  puts totalMech
  puts Mechanic.all.length
  puts (totalMech.to_f/Mechanic.all.length.to_f).to_s
end

task :scrape_desc => :environment do

  require 'nokogiri'
  require 'open-uri'

  Boardgame.all.each do |b|
    gamedoc = Nokogiri::XML(open("http://www.boardgamegeek.com/xmlapi/boardgame/" + b.bgg_id))

    puts "Updating age for " + b.name + "..."
    b.age = gamedoc.css("age").text.squish.to_i
    b.save!
  end
end

task :add_ratings => :environment do

  Boardgame.all.each do |b|

    r1 = b.bgg_rating.to_f
    r2 = b.user_rating.to_f

    rating = (r1+r2)/2

    b.gbg_rating = rating
    b.save!
  end
end

task :bg_year => :environment do

  lowest = 9000
  highest = 0
  Boardgame.all.each do |b|
    year = b.age.to_i
    if year < lowest
      lowest = year
    end

    if year > highest
      highest = year
    end
  end

  puts lowest.to_s
  puts highest.to_s
end

task :amazon_images => :environment do
  require "open-uri"

  Boardgame.all.each do |b|

    puts "Getting image for #{b.name} at #{b.id}"
    b.image = open(b.image_url)
    b.save!
  end
end

task :amazon => :environment do
  Boardgame.all.each do |b|
    if b.id >= 105
      req = Vacuum.new

      game = b.name

      if b.id == 6
        game = "Android Netrunner Living Card Game"
      elsif b.id == 44
        game = "War of the Ring"
      elsif b.id == 71
        game = "The making of the president"
      elsif b.id == 84
        game = "space hulk third edition"
      elsif b.id == 14
        game = "wallenstein"
      end

      game = game.gsub /\s*\(.+\)$/, ''
      game = game.gsub '-', ' '
      game = game.gsub ':', ' '
      game = game.gsub '!', ' '
      game = game.gsub '#', ' '
      game = game.gsub '?', ' '
      game = game.gsub '\'', ' '

      req.configure key:    'AKIAJWEKVGBSCPOG544A',
                    secret: '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',
                    tag:    'getboar-20'

      params = { 'Operation'   => 'ItemSearch',
                 'SearchIndex' => 'All',
                 'Keywords'    => game,
                 'ResponseGroup' => 'Offers,Small'}

      @res = req.get query: params # XPath is your friend.
      doc = Nokogiri.XML(@res.body)

      urlNode = doc.xpath('//xmlns:Item//xmlns:ItemLink//xmlns:URL')[0]
      priceNode = doc.xpath('//xmlns:FormattedPrice')[0]

      if (urlNode && priceNode)
        b.price = priceNode.text
        b.amazon_url = urlNode.text
        b.save!
      else
        puts "Couldn't get value for #{b.name} with #{b.id}"
      end
    end

    sleep(1)
  end
end