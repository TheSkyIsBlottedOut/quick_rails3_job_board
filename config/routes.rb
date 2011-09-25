JobBoard::Application.routes.draw do
  get 'login/login'
  get 'login/logout'
  get 'login/register'
  post 'login/authenticate'
  post 'login/create'
  match 'login' => 'login#login'
  match 'login/validate/:id' => 'login#validate'

  match 'inbox/delete/:id' => 'inbox#delete'
  match 'inbox' => 'inbox#index'
  match 'inbox/view/:id' => 'inbox#view'
  
  resources :jobs do
    member do
      post :comment
    end
  end
  
  root :to => "jobs#index"
end
