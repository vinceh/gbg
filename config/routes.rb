Bgre::Application.routes.draw do

  root :to => 'home#index'
  get 'boardgames' => 'home#bg_list'
  get 'boardgame' => 'boardgames#detail'
end
