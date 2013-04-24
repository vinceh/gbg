Bgre::Application.routes.draw do

  root :to => 'home#index'
  get 'boardgames' => 'home#bg_list'
  get 'boardgame/:id' => 'boardgames#detail'
  get 'test' => 'home#testing'
  get 'search_boardgames' => 'boardgames#search'
  get 'single_search' => 'boardgames#single_search'
  get 'terms' => 'home#terms', :as => 'terms'
  get 'admin' => 'admins#admin'
  get 'controlpanel/newpost' => 'admins#new_post'
  post 'controlpanel/createpost' => 'admins#create_post'
  post 'login' => 'admins#login'
  get 'controlpanel' => 'admins#controlpanel'
  get 'controlpanel/editpost/:id' => 'admins#edit_post'
  put 'controlpanel/updatepost' => 'admins#update_post'
  delete 'controlpanel/deletepost' => 'admins#delete_post'
  get 'blog/:id' => "posts#show"
  get 'logout' => 'admins#logout'

  get 'api/bg' => 'boardgames#retrieve'
end
