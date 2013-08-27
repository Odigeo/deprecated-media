Media::Application.routes.draw do

  scope "/v1" do
    resources :media, :only => [:index, :show, :create, :update, :destroy] do
      member do
        put 'connect'
        put 'disconnect'
      end
    end
  end
  
end
