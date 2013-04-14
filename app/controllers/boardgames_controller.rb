class BoardgamesController < ApplicationController
  def detail
    @bg = Boardgame.find(params[:id]);

    cat = Category.where(:boardgame_id => @bg.id).first
    cats = Boardgame.joins(:categories).where(:categories => {:category_value => cat.category_value}).order('gbg_rating desc').limit(5)
    @similar = []
    cats.each do |c|
      if c.id != @bg.id
        @similar.push(c)
      end
    end


  end

  # API methods
  def retrieve
    bgsq = Boardgame.order("gbg_rating desc").paginate(:page => params[:page], :per_page => 20)

    bgs = {:bgs => []}

    bgsq.each do |b|
      bgs[:bgs].push(
        {
          :id => b.id,
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
          :category => Boardgame.category_map[b.category],
          :aUrl => b.amazon_url,
          :aPrice => b.price
        }
      )
    end

    render :json => bgs.to_json
  end
end
