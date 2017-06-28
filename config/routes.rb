Ez::Settings::Engine.routes.draw do
  scope module: 'ez/settings' do
    root to: 'settings#index'

    get ':group', to: 'settings#show'
    put ':group', to: 'settings#update'
  end
end
