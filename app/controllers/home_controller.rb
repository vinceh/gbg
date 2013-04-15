class HomeController < ApplicationController
  protect_from_forgery

  def index
    @bgs = Boardgame.top_boardgames(5)
  end

  def bg_list

  end

  #def testing
  #  req = Vacuum.new
  #
  #  b = Boardgame.find(params[:id])
  #  game = b.name
  #
  #  game = game.gsub /\s*\(.+\)$/, ''
  #  game = game.gsub '-', ' '
  #  game = game.gsub ':', ' '
  #  game = game.gsub '!', ' '
  #  game = game.gsub '#', ' '
  #  game = game.gsub '?', ' '
  #  game = game.gsub '\'', ' '
  #
  #  req.configure key:    'AKIAJWEKVGBSCPOG544A',
  #                secret: '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',
  #                tag:    'getboar-20'
  #
  #  params = { 'Operation'   => 'ItemSearch',
  #             'SearchIndex' => 'All',
  #             'Keywords'    => game,
  #             'ResponseGroup' => 'Offers,Large'}
  #
  #  @res = req.get query: params # XPath is your friend.
  #  doc = Nokogiri.XML(@res.body)
  #
  #  urlNode = doc.xpath('//xmlns:Item//xmlns:ItemLink//xmlns:URL')[0]
  #  priceNode = doc.xpath('//xmlns:FormattedPrice')[0]
  #
  #  if (urlNode && priceNode)
  #    url = urlNode.text
  #    price  = priceNode.text
  #
  #    b.amazon_url = url
  #    b.price = price
  #    b.save!
  #  end
  #
  #  #render :text => "#{game}: #{price} @ #{url}"
  #   render :xml => doc
  #end

  def testing

    bgs = {
      :boardgames => []
    }

    Boardgame.all.each_with_index do |bg, i|

      bgs[:boardgames].push(
        {
          :name => bg.name,
          :bgg_rating => bg.bgg_rating,
          :user_rating => bg.user_rating,
          :num_votes => bg.num_votes,
          :bgg_id => bg.bgg_id,
          :year_published => bg.year_published,
          :min_num_players => bg.min_num_players,
          :max_num_players => bg.max_num_players,
          :playing_time => bg.playing_time,
          :image_url => bg.image_url,
          :image_file_name => bg.image_file_name,
          :image_file_size => bg.image_file_size,
          :image_content_type => bg.image_content_type,
          :image_updated_at => bg.image_updated_at,
          :desc => bg.desc,
          :age => bg.age,
          :gbg_rating => bg.gbg_rating,
          :price => bg.price,
          :amazon_url => bg.amazon_url,
          :categories => [],
          :honours => [],
          :mechanics => [],
          :subdomains => []
        }
      )

      cats = Category.where(:boardgame_id => bg.id)

      cats.each do |c|
        bgs[:boardgames][i][:categories].push(
          {
            :category_value => c.category_value
          }
        )
      end

      hon = Honour.where(:boardgame_id => bg.id)

      hon.each do |c|
        bgs[:boardgames][i][:honours].push(
          {
            :honour_value => c.honour_value
          }
        )
      end

      mech = Mechanic.where(:boardgame_id => bg.id)

      mech.each do |c|
        bgs[:boardgames][i][:mechanics].push(
          {
            :mechanic_value => c.mechanic_value
          }
        )
      end

      sub = Subdomain.where(:boardgame_id => bg.id)

      sub.each do |c|
        bgs[:boardgames][i][:subdomains].push(
          {
            :subdomain_value => c.subdomain_value
          }
        )
      end

    end

    render :json => bgs.to_json
    #render :text => body["items"].length
  end

  def grab
    require 'net/http'

    url = URI.parse('http://70.71.29.87:3000/test')
    req = Net::HTTP::Get.new(url.path, initheader = {'Content-Type' =>'application/json'})
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts res.body

    bgs = JSON.parse(res.body)

    #render :json => JSON.pretty_generate(JSON.parse(res.body))

    bgs['boardgames'].each_with_index do |b, i|

      bg = Boardgame.new
      bg.name = b['name']
      bg.bgg_rating = b['bgg_rating']
      bg.user_rating = b['user_rating']
      bg.num_votes = b['num_votes']
      bg.bgg_id = b['bgg_id']
      bg.year_published = b['year_published']
      bg.min_num_players = b['min_num_players'].to_i
      bg.max_num_players = b['max_num_players'].to_i
      bg.playing_time = b['playing_time'].to_i
      bg.image_url = b['image_url']
      bg.image_file_name = b['image_file_name']
      bg.image_file_size = b['image_file_size']
      bg.image_content_type = b['image_content_type']
      bg.image_updated_at = b['image_updated_at']
      bg.desc = b['desc']
      bg.age = b['age'].to_i
      bg.gbg_rating = b['gbg_rating'].to_f
      bg.price = b['price']
      bg.amazon_url = b['amazon_url']

      bg.save!
      b['categories'].each do |c|

        cat = Category.new
        cat.boardgame_id = bg.id
        cat.category_value = c['category_value']

        cat.save!
      end

      b['honours'].each do |c|

        cat = Honour.new
        cat.boardgame_id = bg.id
        cat.honour_value = c['honour_value']

        cat.save!
      end

      b['mechanics'].each do |c|

        cat = Mechanic.new
        cat.boardgame_id = bg.id
        cat.mechanic_value = c['mechanic_value']

        cat.save!
      end

      b['subdomains'].each do |c|

        cat = Subdomain.new
        cat.boardgame_id = bg.id
        cat.subdomain_value = c['subdomain_value']

        cat.save!
      end
    end

    render :text => bgs['boardgames'].length
  end

  private

  def vidExist(vids, vid)
    vids.each do |v|
      if v[:videoId] == vid[:videoId]
        return true
      end
    end

    false
  end

  def parseVideo(vid)
    return {
      :title => vid["snippet"]["title"],
      :thumbnail => vid["snippet"]["thumbnails"]["high"]["url"],
      :videoId => vid["id"]["videoId"],
    }
  end

  def youtube(options)

    if options[:channelId]
      url = URI.parse("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=#{options[:maxResults]}&q=#{options[:q]}%20review&key=AIzaSyALrXdHmy3so_PNiAIYRfNZeDBFyaF4sW4&type=video&videoDefinition=high&channelId=#{options[:channelId]}&videoEmbeddable=true")
    else
      url = URI.parse("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=#{options[:maxResults]}&q=#{options[:q]}%20review&key=AIzaSyALrXdHmy3so_PNiAIYRfNZeDBFyaF4sW4&type=video&videoDefinition=high&videoEmbeddable=true")
    end

    req = Net::HTTP::Get.new(url.to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    response = http.request(req)

    return JSON.parse(response.body)
  end
end
