Bgre::Application.routes.draw do

  root :to => 'home#index'
  get 'boardgames' => 'home#bg_list'
  get 'boardgame/:id' => 'boardgames#detail'
  get 'test' => 'home#testing'
  get 'search_boardgames' => 'boardgames#search'
  get 'single_search' => 'boardgames#single_search'
  get 'terms' => 'home#terms', :as => 'terms'
  #get 'grab' => 'home#grab'

  get 'api/bg' => 'boardgames#retrieve'
end
