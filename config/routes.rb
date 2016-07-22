require 'api_constraints'
Rails.application.routes.draw do
  devise_for :users
  namespace :api, defaults: { format: :json },
                              constraints: { subdomain: 'api' }, path: '/'  do
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
    	resources :users
    	resources :sessions, :only => [:create,:destroy]
      post '/users/signup', to: 'users#new', as: "new_user" #done
      post '/users/:id/basicinfo', to: 'users#info', as: "info_user" #done
      post '/users/:id/poststory', to: 'users#poststory' #done
      get '/users/:id/likestory', to: 'users#likestory' #done
      get '/users/:id/posts', to: 'users#userposts' #done
      post '/:myid/follow', to: 'users#follow' #done
      get 'users/:id/showprofile', to: 'users#showprofile' #done
      get 'users/:myid/:hisid/checkfollowing', to: 'users#checkfollowing'
      get '/users/:id/discover', to: 'users#discover' #done
      get '/users/:query/:parameter/search', to: 'users#search' #done


       resources :feeds, :only => [:index]
       post '/feeds/:uid/create', to: 'feeds#create', as: "create_feed" #done
       get '/feeds/:uid/nearbyfeeds', to: 'feeds#nearbyfeeds', as: "nearby_feed" #done
       get '/feeds/:uid/followedfeeds', to: 'feeds#followeduserfeeds' #done
       get '/feeds/:id/time', to: 'feeds#timeelapsed' 

       post 'feeds/:pid/comment', to: 'comments#addcomment', as: "comment_users" #done
       get 'feeds/:pid/showcomment', to: 'comments#showcomment' #done

       post '/feeds/:pid/like', to: 'feeds#likeit' #done
       get '/feeds/:pid/showlike', to: 'feeds#showlikes' #done
       post '/feeds/:pid/dislike', to: 'feeds#dislikeit' #done

       post '/feeds/:pid/report', to: 'feeds#report' #done

       resources :adoptions
       post '/adopt/:id/createadoption', to: 'adoptions#newadoption' #done
       get '/adopt/show', to: 'adoptions#show' #done

       resources :conversations, :only => [:create]
       get '/conversations/:sender_id/:recipient_id/open', to: 'conversations#open' #done
       get '/conversations/:id/all', to: 'conversations#all'
       
    end
  end
end
