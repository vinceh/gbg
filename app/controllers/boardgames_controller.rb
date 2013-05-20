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
          :parameter => b.parameter,
          :rating => b.gbg_rating,
          :year => b.year_published,
          :minPlayers => b.min_num_players,
          :maxPlayers => b.max_num_players,
          :time => b.playing_time,
          :image => b.image.url(:thumb),
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

  def search

    render :json => Boardgame.search_bg(params[:term])
  end

  def single_search

    bg = Boardgame.single_search(params[:term])
    if bg.length == 1
      render :json => {:id => bg[0]}
    else
      render :json => {:id => nil}
    end
  end
end
