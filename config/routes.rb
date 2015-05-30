Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'dashboard#index'
  # get 'users/manage'     => 'manageusers#index'
  # get 'users/manage/:id' => 'manageusers#edit', :as => :user
  # patch 'users/manage/:id' => 'manageusers#update'
  resources :manageusers, path: '/users/manage', as: :user
  resources :servers do
    post   'add_satellite/:id'              => 'servers#add_satellite'
    post   'add_all_satellites'             => 'servers#add_all_satellites'
    delete 'remove_satellite/:id'           => 'servers#remove_satellite'
    post   'add_notification/:id'           => 'servers#add_notification'
    post   'add_all_notifications'          => 'servers#add_all_notifications'
    delete 'remove_notification/:id'        => 'servers#remove_notification'
    post   'notification_fail_count_up/:id' => 'servers#notification_fail_count_up'
    post   'notification_fail_count_down/:id' => 'servers#notification_fail_count_down'
  end
  resources  :satellites
  resources  :notifications

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
