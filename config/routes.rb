Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root 'dashboard#index'

  resources :manageusers, path: '/users/manage', as: :user

  resources :servers do
    post   'add_satellite/:id'                => 'servers#add_satellite'
    post   'add_all_satellites'               => 'servers#add_all_satellites'
    delete 'remove_satellite/:id'             => 'servers#remove_satellite'
    post   'add_notification/:id'             => 'servers#add_notification'
    post   'add_all_notifications'            => 'servers#add_all_notifications'
    delete 'remove_notification/:id'          => 'servers#remove_notification'
    post   'notification_fail_count_up/:id'   => 'servers#notification_fail_count_up'
    post   'notification_fail_count_down/:id' => 'servers#notification_fail_count_down'
    resources :checks do
      post '/disable_check' => 'checks#disable_check'
      post '/enable_check' => 'checks#enable_check'
    end
  end

  resources  :satellites
  resources  :notifications

end
