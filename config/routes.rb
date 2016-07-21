require 'api_constraints'
Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
    	resources :users, :only => [:show,:destroy,:new,:info]
    	resources :sessions, :only => [:create,:destroy]
      post 'signup', to: 'users#new', as: "new_user"
      post '/users/:id/basicinfo', to: 'users#info', as: "info_user"
      post '/users/:id/poststory', to: 'users#poststory'
      post '/users/:id/likestory', to: 'users#likestory'
      get '/users/:id/posts', to: 'users#userposts'
      post '/:myid/follow', to: 'users#follow'
      post '/:hisid/showprofile', to: 'users#showprofile'
      get '/users/:id/discover', to: 'users#discover'
      get '/users/:query/:parameter/search', to: 'users#search'


       resources :feeds, :only => [:index]
       post '/feeds/:id/create', to: 'feeds#create', as: "create_feed"
       #get '/feeds/trending', to: 'feeds#trending', as: "trending_feed"
       get '/feeds/:id/nearbyfeeds', to: 'feeds#nearbyfeeds', as: "nearby_feed"
       get '/feeds/:id/followedfeeds', to: 'feeds#followeduserfeeds'
       get '/feeds/:id/time', to: 'feeds#timeelapsed'

       post '/:uid/comment', to: 'comments#addcomment', as: "comment_users"
       get '/:pid/showcomment', to: 'comments#showcomment'

       post '/feeds/:pid/like', to: 'feeds#likeit'
       get '/feeds/:pid/showlike', to: 'feeds#showlikes'
       post '/feeds/:pid/dislike', to: 'feeds#dislikeit'

       post '/feeds/:pid/report', to: 'feeds#report'

       resources :adoptions
       post '/adopt/:id/createadoption', to: 'adoptions#newadoption'
       get '/adopt/show', to: 'adoptions#show'

       resources :conversations, :only => [:create]
       post '/conversations/open', to: 'conversations#open'
       post '/conversations/all', to: 'conversations#all'

      
    end
  end
end
