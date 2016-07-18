require 'api_constraints'
Rails.application.routes.draw do
  devise_for :users
# Api definition
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
      # We are going to list our resources here
    	resources :users, :only => [:show,:destroy,:new,:info]
    	resources :sessions, :only => [:create,:destroy]
      post 'signup', to: 'users#new', as: "new_user"
      post '/users/:id/basicinfo', to: 'users#info', as: "info_user"
       #resources :products, :only => [:show,:index]
      post '/users/:id/poststory', to: 'users#poststory'
      post '/users/:id/likestory', to: 'users#likestory'
      get '/users/:id/posts', to: 'users#userposts'
      post '/:myid/follow', to: 'users#follow'
      post '/:hisid/showprofile', to: 'users#showprofile'


       resources :feeds, :only => [:index]
       post '/feeds/:id/create', to: 'feeds#create', as: "create_feed"
       #get '/feeds/trending', to: 'feeds#trending', as: "trending_feed"
       get '/feeds/:id/nearbyfeeds', to: 'feeds#nearbyfeeds', as: "nearby_feed"

       post '/:uid/comment', to: 'comments#addcomment', as: "comment_users"
       get '/:pid/showcomment', to: 'comments#showcomment'

       post '/feeds/:uid/like', to: 'feeds#likeit'
       get '/feeds/:pid/showlike', to: 'feeds#showlikes'
       post '/feeds/:pid/report', to: 'feeds#report'

       resources :adoptions
       post '/adopt/:id/createadoption', to: 'adoptions#newadoption'
       get '/adopt/show', to: 'adoptions#show'

       resources :conversations, :only => [:create]
       post '/conversations/open', to: 'conversations#open'
       post '/conversations/all', to: 'conversations#all'

       #match '/feeds/:post_id/like' to: 'feeds#likeit', via: 'put'
       #put '/feeds/:post_id/dislike', to: 'feeds#dislikeit', as: "dislike_feed"

       #post '/feeds/:id/report', to: 'feeds#report', as: "report_feed"
    end
  end
end
