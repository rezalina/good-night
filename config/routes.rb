Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  post '/users/:id/follow' => 'relationships#follow'
  post '/users/:id/unfollow' => 'relationships#unfollow'

  get '/users/:id/followers' => 'users#followers'
  get '/users/:id/following' => 'users#following'

  post '/users/:id/clock-in' => 'users#clock_in'
  post '/users/:id/clock-out' => 'users#clock_out'

  get '/users/:id/sleep-records' => 'users#sleep_records'
  get '/users/:id/following-sleep-records' => 'users#following_sleep_records'
end
