Bgre::Application.routes.draw do

  root :to => 'home#index'
  get 'boardgames' => 'home#bg_list'
  get 'boardgame/:id' => 'boardgames#detail'
  get 'test' => 'home#testing'
  #get 'grab' => 'home#grab'

  get 'api/bg' => 'boardgames#retrieve'
end
