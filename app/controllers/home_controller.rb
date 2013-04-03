class HomeController < ApplicationController
  protect_from_forgery

  def index
    @bgs = Boardgame.top_boardgames(5)
  end

  def bg_list

  end
end
