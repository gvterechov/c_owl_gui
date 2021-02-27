Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'

  routes = -> do
    get "/tasks/:token", to: 'application#show_task'
    post :create_task, to: 'application#create_task', format: :json
  end

  routes.call

  scope ":locale", locale: /#{I18n.available_locales.join('|')}/ do
    root 'application#index', as: :root_with_locale
    routes.call
  end
end
