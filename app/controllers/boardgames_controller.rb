class BoardgamesController < ApplicationController
  def detail

  end

  # API methods
  def retrieve
    bgsq = Boardgame.order("gbg_rating desc").paginate(:page => params[:page], :per_page => 20)

    bgs = {:bgs => []}

    bgsq.each do |b|
      bgs[:bgs].push(
        {
          :name => b.name,
          :rating => b.gbg_rating,
          :year => b.year_published,
          :minPlayers => b.min_num_players,
          :maxPlayers => b.max_num_players,
          :time => b.playing_time,
          :image => b.image_url,
          :desc => b.desc,
          :age => b.age,
          :mechanic => b.mechanic,
          :category => Boardgame.category_map[b.category]
        }
      )
    end

    render :json => bgs.to_json
  end
end
