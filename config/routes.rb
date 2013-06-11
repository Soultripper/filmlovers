Filmlovers::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "sessions", :registrations => "registrations"}

  root :to => 'app#index'

  match 'auth/:provider/callback',  to: 'sessions#create'
  match 'auth/failure',             to: redirect('/')
  match 'signout',                  to: 'sessions#destroy', as: 'signout'
  match 'login',                    to: 'app#login', as: 'login'
  match 'pusher/auth' => 'pusher#auth', as: 'pusher_auth'
  get 'current_user' => 'sessions#currentuser'

  get 'users', to: 'users#index', as: 'users'

  match 'templates/:action' => "templates#:action", as: 'templates'

  resources 'films',        only: [:show, :index] do
    collection do
      resources 'genres',   only: [:show, :index]
      resources 'trends',   only: [:show, :index], :constraints => {:id => /now_playing|latest|upcoming|popular/}
      # 
      post ':id' => redirect("/films/%{id}")
      get 'search'  
      get 'inline_search'   
      get ':user_action',        to: "films#actioned", constraints: {user_action: /search|quick_search|watched|loved|owned/}, as: 'actioned'
    end
    member do
      get ':view',          to: 'films#view', :constraints => { :view => /images|overview|cast|trailer|similar/ }, as: 'view'
      get 'summary',        to: "films#summary",        as: 'summary'
      get ':user_action',   to: "films#users", as: 'users', :constraints => { :user_action => /watched|loved|owned/ }
      get 'list_view',      to: "films#list_view",  as: 'list_view'
      get 'trailer_popup',  to: "films#trailer_popup" , as: 'trailer_popup'
    end


  end

  resources 'persons', only: [:show, :index] do
    collection do 
      get 'search'
      get 'quick_search'
    end
  end

  resources 'channels' do
    collection do
      get 'facebook'
    end
  end

  resources :lists, :except => [:show] do
    resources :films, to: 'film_lists', :only => [:update, :destroy, :show, :create, :new]
  end

  scope 'queue' do
    put 'list/:id', to: 'queue#update_list', as: 'queue_to_list'
  end

  scope 'site' do
    get ':action', to: 'site', as: 'site'
  end

  resources 'friendships', :constraints => { :id => /.*/ } do
    member do
      put 'block'
      put 'unblock'
    end
  end

  namespace :facebook do
    get  'credits' => "credits#index",               as:'shop'
    post 'credits' => "credits#callback",            as:'shop_callback'
    get  'invite'  => "friends#index",               as:'invite'
    post 'invite'  => "friends#invite",              as:'send_invites'
    scope 'social' do
      match 'films/:id'       => 'social#share',     as: 'share', constraints: {type: /achievement|levelup|new_game/}, via: :get
      match 'activity'        => "social#activity",  as: 'activity', via:[:get, :post]
      get  'liked'            => "social#liked",     as:'liked'
    end
  end


  resources 'recommendations'

  scope ':user_id', :constraints => { :user_id => /.*/ } do
    resources :films, :only => [:index, :show], to: 'users#show', :constraints => { :id => /watched|loved|queued|owned/ }, as: 'user_film' do 
        member do 
          put ':film_id',     to: 'user_films#update',  as: 'update'
          delete ':film_id',  to: 'user_films#destroy', as: 'update'
        end
      end
    resources :lists,         to: 'user_lists',         as: 'user_lists', :only => [:show, :index]
    match 'queue/:action',    to: "queue",              as: 'queue',:constraints => {:action => /list|recommend|show/},  via: :get
    # get '', to: 'show'
  end

  get '/:user_id', to: 'users#show', as: 'user', :constraints => { :user_id => /.*/ }


end
