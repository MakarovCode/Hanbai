Rails.application.routes.draw do
	devise_for :admin_users, ActiveAdmin::Devise.config
	ActiveAdmin.routes(self)
	devise_for :users

	root to: "landing/home#index"

	mount EasyPayULatam::Engine, at: "/easy_pay_u_latam"

	namespace :landing do
		resources :home, only: [:index]

		resources :contacts, only: [:create]
	end

	namespace :blog do
		resources :posts, only: [:index, :show]
	end

	namespace :app do

		resources :stats, only: [:index]

		resources :users, only: [:edit, :update] do
			resources :account, only: [:index, :create]
			resources :payments, only: [:index, :show]
		end

		resources :funnels, only: [:index]

		resources :activities, only: [:index, :show]

		resources :people, only: [:index, :show]

		resources :extra_fields, only: [:index]

		resources :organizations, only: [:index, :show]

		namespace :api do
			namespace :v1 do
				resources :organizations do
					collection do
						post "import"
						get "autocomplete"
					end
				end
				resources :people do
					collection do
						post "import"
						get "autocomplete"
					end
					member do
						post "create_phone"
						post "create_email"
						post "create_address"
						delete "delete_phone"
						delete "delete_email"
						delete "delete_address"
					end
				end

				resources :extra_fields, only: [:index, :create, :update, :destroy]
				
				resources :funnels do
					member do
						post "invite_member"
						post "remove_member"
						post "change_member_permissions"
					end

				end
				resources :stages
				resources :deals do
					collection do
						get "autocomplete"
					end
					member do
						post "change_status"
						post "invite_member"
						post "remove_member"
					end
				end
				resources :activities do
					member do
						post "change_status"
					end
				end
				resources :notes
				resources :users, only: [:index, :show]
				resources :logs, only: [:index]
			end
		end
	end
end
