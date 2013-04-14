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

    require 'net/http'
    require 'json'

    game = "Dominion"

    url = URI.parse("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=5&q=#{game}&key=AIzaSyALrXdHmy3so_PNiAIYRfNZeDBFyaF4sW4")
    req = Net::HTTP::Get.new(url.to_s)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    body = JSON.parse(response.body)

    render :json => JSON.pretty_generate(body)
  end
end
