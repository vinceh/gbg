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