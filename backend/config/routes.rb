Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create,:update,:show] do
          collection do
            get 'logged_in'
            post 'sign_in' => 'users#signin'
          end
        end
    end
  end

  scope 'api/v1/' do
    devise_for :users, path: '/auth' , sign_out_via: [:get, :delete]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
