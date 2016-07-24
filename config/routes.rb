require 'api_constraints'
Rails.application.routes.draw do
  root to: 'application#show'
  devise_for :users
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
    	resources :users
      post '/users/signup', to: 'users#new', as: "new_user" #done #checked
      post '/users/:id/basicinfo', to: 'users#info', as: "info_user" #done #checked
      post '/users/:id/poststory', to: 'users#poststory' #done #checked
      get '/users/:id/likestory', to: 'users#likestory' #done #checked
      get '/users/:id/posts', to: 'users#userposts' #done #checked
      post '/:myid/follow', to: 'users#follow' #done #working adding record but giving 500 error on return
      get 'users/:id/showprofile', to: 'users#showprofile' #done #checked
      get 'users/:myid/:hisid/checkfollowing', to: 'users#checkfollowing' #done #checked
      get '/users/:id/discover', to: 'users#discover' #done #checked
      get '/users/:query/:parameter/search', to: 'users#search' #done #checked
      get '/users/:id/notifications', to: 'users#notification' #problem

      resources :sessions
      post '/users/login', to: 'sessions#create' #problem


       resources :feeds, :only => [:index] 
       post '/feeds/:uid/create', to: 'feeds#create', as: "create_feed" #done #checked
       get '/feeds/:uid/nearbyfeeds', to: 'feeds#nearbyfeeds', as: "nearby_feed" #done #checked
       get '/feeds/:uid/followedfeeds', to: 'feeds#followeduserfeeds' #done #checked
       get '/feeds/:id/time', to: 'feeds#timeelapsed' 

       post 'feeds/:pid/comment', to: 'comments#addcomment', as: "comment_users" #done #comment is added but giving 500 error, problem in notification
       get 'feeds/:pid/showcomment', to: 'comments#showcomment' #done #checked

       post '/feeds/:pid/like', to: 'feeds#likeit' #done #problem
       get '/feeds/:pid/showlike', to: 'feeds#showlikes' #done #problem
       post '/feeds/:pid/dislike', to: 'feeds#dislikeit' #done #check later

       post '/feeds/:pid/report', to: 'feeds#report' #done #problem

       resources :adoptions
       post '/adopt/:id/createadoption', to: 'adoptions#newadoption' #done #checked
       get '/adopt/show', to: 'adoptions#show' #done #checked

       resources :conversations, :only => [:create] #done #checked
       get '/conversations/:sender_id/:recipient_id/open', to: 'conversations#open' #done #checked
       get '/conversations/:id/all', to: 'conversations#all' #done #checked
       
    end
  end
end
