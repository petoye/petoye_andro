require 'api_constraints'
Rails.application.routes.draw do
  root to: 'application#show'
  devise_for :users
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
    	resources :users
      post '/users/signup', to: 'users#new', as: "new_user" #working
      post '/users/:id/basicinfo', to: 'users#info', as: "info_user" #working
      post '/users/:id/poststory', to: 'users#poststory' #working
      get '/users/:id/likestory', to: 'users#likestory' #working
      get '/users/:id/posts', to: 'users#userposts' #working
      post '/:myid/follow', to: 'users#follow' #working
      get 'users/:id/showprofile', to: 'users#showprofile' #working
      get 'users/:myid/:hisid/checkfollowing', to: 'users#checkfollowing' #working
      get '/users/:id/discover', to: 'users#discover' #working
      get '/users/:query/:parameter/search', to: 'users#search' #working
      get '/users/:id/notifications', to: 'users#notification' #working

      resources :sessions
      post '/users/login', to: 'sessions#new' #working


       resources :feeds, :only => [:index] 
       post '/feeds/:uid/create/:message', to: 'feeds#create', as: "create_feed" #working
       get '/feeds/:uid/nearbyfeeds', to: 'feeds#nearbyfeeds', as: "nearby_feed" #working
       get '/feeds/:uid/followedfeeds', to: 'feeds#followeduserfeeds' #working
       get '/feeds/:id/time', to: 'feeds#timeelapsed' 

       post 'feeds/:pid/comment', to: 'comments#addcomment', as: "comment_users" #working
       get 'feeds/:pid/showcomment', to: 'comments#showcomment' #working

       post '/feeds/:pid/like', to: 'feeds#likeit' #working #removed serialize: array from feeds model
       get '/feeds/:pid/showlike', to: 'feeds#showlikes' #working
       post '/feeds/:pid/dislike', to: 'feeds#dislikeit' #working

       post '/feeds/:pid/report', to: 'feeds#report' #working

       resources :adoptions
       post '/adopt/:id/createadoption', to: 'adoptions#newadoption' #working
       get '/adopt/show', to: 'adoptions#show' #working

       resources :conversations, :only => [:create] #working
       get '/conversations/:sender_id/:recipient_id/open', to: 'conversations#open' #working
       get '/conversations/:id/all', to: 'conversations#all' #working
       
    end
  end
end
