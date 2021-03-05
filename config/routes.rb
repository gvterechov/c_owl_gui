Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'

  routes = -> do
    get "/tasks/:token", to: 'application#show_task'
    get :check_expression, to: 'application#check_expression', format: :json
    post :create_task, to: 'application#create_task', format: :json
    post :verify_trace_act, to: 'application#verify_trace_act', format: :json
  end

  routes.call

  scope ":locale", locale: /#{I18n.available_locales.join('|')}/ do
    root 'application#index', as: :root_with_locale
    routes.call
  end
end
