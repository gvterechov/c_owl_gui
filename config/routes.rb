Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#index'
  get :task, to: 'application#task'

  scope ":locale", locale: /#{I18n.available_locales.join('|')}/ do
    root 'application#index', as: :root_with_locale
    get :task, to: 'application#task'
  end
end
