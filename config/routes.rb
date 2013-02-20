SuyaVuthavi::Application.routes.draw do


  # devise_for :users
  devise_for :users,
           :controllers  => {
             :registrations => 'custom_devise/registrations',
             # :passwords => 'custom_devise/passwords',
             :sessions => 'custom_devise/sessions'
             # :omniauth_callbacks => "custome_devise/omniauth_callbacks"
           } 

  devise_scope :user do
    get "signout",  :to => "custom_devise/sessions#destroy",  :as => :signout
    get "signin",   :to => "custom_devise/sessions#new", :as => :signin
    get "signup",   :to => "custom_devise/registrations#new", :as => :signup
    get "forgot_password",   :to => "custom_devise/passwords#new", :as => :forgot_password
    get '/users/auth/:provider' => 'custom_devise/omniauth_callbacks#passthru'
  end          

  root :to => "home#index"

  resources :users do
    get :list, :on => :collection
  end  
  resources :groups
  resources :banks
  resources :account_transactions, :only => "index" do 
    get :member_transaction, :on => :collection
    get :group_transaction, :on => :collection
    get :bank_transaction, :on => :collection
    get :load_members, :on => :collection
    get :load_groups, :on => :collection
    get :load_banks, :on => :collection
    get :save_member_transaction, :on => :collection
    get :save_group_transaction, :on => :collection
    get :save_bank_transaction, :on => :collection
    get :show_transactions, :on => :collection
    get :load_group_balances, :on => :collection
    get :expenses, :on => :collection
    get :save_expenses, :on => :collection
  end  

  resources :reports, :only => "index" do 
    get :loan_details, :on => :collection
    get :load_loan_details, :on => :collection
    get :group_loan_details, :on => :collection
    get :group_load_loan_details, :on => :collection
    get :monthly_loan_details, :on => :collection
    get :load_monthly_loan_details, :on => :collection
    get :grand_details, :on => :collection
    get :load_grand_details, :on => :collection
  end 

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id))(.:format)'
end