Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  root 'dashboard#index'
  get 'failed'        => 'dashboard#failed'
  get 'passed'        => 'dashboard#passed'
  get 'check_details' => 'dashboard#check_details'

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
      post '/enable_check'  => 'checks#enable_check'
      get  '/availability'  => 'checks#availability'
      resources :checks_schedules
    end
  end

  resources  :satellites
  resources  :notifications do
    post   'add_server/:id'    => 'notifications#add_server'
    post   'add_all_servers'   => 'notifications#add_all_servers'
    delete 'remove_server/:id' => 'notifications#remove_server'
    resources :notifications_schedules
  end
  resource  :settings, only: [:index] do
    get   '/',         to: 'settings#index'
    get   '/rabbitmq', to: 'settings#rabbitmq'
    patch '/rabbitmq', to: 'settings#rabbitmq_update'
    get   '/turbosms',   to: 'settings#turbosms'
    patch '/turbosms',   to: 'settings#turbosms_update'
    get   '/general',   to: 'settings#general'
    patch '/general',   to: 'settings#general_update'
    get   '/slack',   to: 'settings#slack'
    patch '/slack',   to: 'settings#slack_update'
  end
end
