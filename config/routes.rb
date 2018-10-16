Rails.application.routes.draw do

  resources :users, only: [:show, :index, :edit, :update]

  scope :stats do
    get 'hours' => 'stats#hours', as: 'hour_stats'
    get ':user_id' => 'stats#show', as: 'stats'
    get '' => 'stats#index', as: 'all_stats'
  end
  get 'get_stats' => 'stats#get_stats', as: 'get_stats'

  put '/sessions(.:format)' => 'sessions#update'

  resources :sessions, except: :show

  get '/auth/:provider/callback', to: 'login#create'

  root 'sessions#index'
end
